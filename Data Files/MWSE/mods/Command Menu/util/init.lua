local config = require("Command Menu.config")

local i18n = mwse.loadTranslations("Command Menu")
local log = mwse.Logger.new()
local util = {}

--- @param faction tes3faction
function util.getFactionLabel(faction)
	if not faction.playerJoined then
		return i18n("Status: not a member.")
	end
	if faction.playerExpelled then
		return i18n("Status: expelled.")
	end
	return string.format(i18n("Status: member, rank") .. ": %s.",
		faction:getRankName(faction.playerRank)
	)
end

--- https://stackoverflow.com/questions/2421695/first-character-uppercase-lua
--- @param str string
function util.capitalize(str)
	return (str:gsub("^%l", string.upper))
end

--- This can be replaced with fuzzy or wildcard matching.
--- @param str string
--- @param substr string
function util.ciContains(str, substr)
	return (str:lower():find(substr, 1, true)) and true or false
end

-- For "<Deprecated>", "<Template>", "< DEPRECATED >" etc.
--- @param str string
function util.isNameDeprecated(str)
	return string.sub(str, 1, 1) == "<"
end

--- @param object tes3creature|tes3item|tes3faction|tes3npc
function util.getNiceName(object)
	if util.isNameDeprecated(object.name) then
		return string.format("%s (%s)", object.name, object.id)
	end
	return object.name
end

function util.getStartingCreature()
	return tes3.getObject("guar") --[[@as tes3creature]]
end

local offset = tes3vector3.new(0, 128, 0)

function util.getPointInFrontOfPlayer()
	local pos = tes3.player.position:copy()
	local rot = tes3matrix33.new()
	rot:toRotationZ(tes3.mobilePlayer.facing)
	pos = pos + rot * offset
	return pos
end

--- @param cell tes3cell
--- @return tes3vector3
function util.getTeleportPosition(cell)
	local doorMarker = tes3.getObject("DoorMarker")
	for reference in cell:iterateReferences(tes3.objectType.static) do
		if reference.object == doorMarker then
			return reference.position
		end
	end

	-- Fallback, use first available persistent ref, if there is one.
	local firstRef = cell.activators[1]
	if firstRef then
		return firstRef.position
	end

	-- We rely on engine to trace the Z coordinate to the ground.
	return tes3vector3.new(cell.gridX * 8192 + 4096, cell.gridY * 8192 + 4096, -1000)
end

--- @param object tes3object|tes3armor|tes3misc|tes3cell|tes3faction
function util.isObjectDeprecated(object)
	if not config.filterOutDeprecated then
		return false
	end

	if object.name and util.isNameDeprecated(object.name) then
		return true
	end

	return false
end

--- @param object tes3object|tes3npc
function util.isValidNpc(object)
	-- Filter out cloned actors so we don't have duplicates.
	if object.objectType == tes3.objectType.npc and not object.isInstance then
		-- Make sure we only list NPC eligible for teleporting that are placed in the in-game world.
		-- TODO test if this significantly slows down the whole thing
		if tes3.getReference(object.id) then
			return true
		end
	end
	return false
end

--- @param a tes3armor|tes3misc|tes3spell|tes3cell
--- @param b tes3armor|tes3misc|tes3spell|tes3cell
--- @return boolean
local function nameSorter(a, b)
	local aName = a.name or a.editorName
	local bName = b.name or b.editorName
	if aName == "<Deprecated>" then
		aName = a.id
	end
	if bName == "<Deprecated>" then
		bName = b.id
	end
	return aName < bName
end

function util.getSoulGems()
	--- @type tes3misc[]
	local soulGems = {}

	for _, object in ipairs(tes3.dataHandler.nonDynamicData.objects) do
		if object.objectType == tes3.objectType.miscItem and object.isSoulGem
			and not util.isObjectDeprecated(object) then
			table.insert(soulGems, object)
		end
	end
	table.sort(soulGems, nameSorter)

	return soulGems
end

return util
