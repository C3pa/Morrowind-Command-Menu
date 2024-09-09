local util = require("Command Menu.util")

local i18n = mwse.loadTranslations("Command Menu")
local this = {}

--- @type tes3uiMenuController
local menuController

event.register(tes3.event.initialized, function()
	menuController = tes3.worldController.menuController
end)


function this.toggleGodMode()
	menuController.godModeEnabled = not menuController.godModeEnabled
end

--- @param enabled boolean
function this.setGodMode(enabled)
	menuController.godModeEnabled = enabled
end

function this.toggleCollision()
	menuController.collisionDisabled = not menuController.collisionDisabled
end

--- @param enabled boolean
function this.setCollsion(enabled)
	menuController.collisionDisabled = not enabled
end

function this.toggleFogOfWar()
	menuController.fogOfWarDisabled = not menuController.fogOfWarDisabled
end

--- @param enabled boolean
function this.setFogOfWar(enabled)
	menuController.fogOfWarDisabled = not enabled
end

function this.toggleAI()
	menuController.aiDisabled = not menuController.aiDisabled
end

--- @param enabled boolean
function this.setAI(enabled)
	menuController.aiDisabled = not enabled
end

function this.toggleWireframe()
	menuController.wireframeEnabled = not menuController.wireframeEnabled
end

--- @param enabled boolean
function this.setWireframe(enabled)
	menuController.wireframeEnabled = enabled
end

function this.toggleVanityMode()
	tes3.setVanityMode({ toggle = true })
end

--- @param enabled boolean
function this.setVanityMode(enabled)
	tes3.setVanityMode({
		enabled = enabled,
		checkVanityDisabled = false,
	})
end

function this.resetActors()
	tes3.runLegacyScript({ command = "ResetActors" })
end

function this.fixMe()
	tes3.runLegacyScript({ command = "FixMe" })
end

function this.fillMap()
	tes3.runLegacyScript({ command = "FillMap" })
end

function this.fillJournal()
	tes3.runLegacyScript({ command = "FillJournal" })
end

function this.enableStatReviewMenu()
	tes3.runLegacyScript({ command = "EnableStatReviewMenu" })
end

function this.clearBounty()
	tes3.runLegacyScript({ command = "SetPCCrimeLevel 0" })
end

function this.clearStolenFlag()
	if tes3.onMainMenu() then
		return false
	end

	for _, i in ipairs(tes3.mobilePlayer.inventory) do
		tes3.setItemIsStolen({
			item = i.object,
			stolen = false
		})
	end
end

function this.rechargePowers()
	if tes3.onMainMenu() then
		return false
	end

	for _, power in ipairs(tes3.getSpells({ target = tes3.player, spellType = tes3.spellType.power })) do
		tes3.mobilePlayer:rechargePower(power)
	end
end

function this.killHostiles()
	if tes3.onMainMenu() then
		return false
	end
	for _, hostile in ipairs(tes3.mobilePlayer.hostileActors) do
		hostile:kill()
	end
end

--- @param faction tes3faction
--- @return boolean joined
function this.joinFaction(faction)
	if faction.playerJoined then
		return false
	end
	faction.playerJoined = true
	tes3ui.updateStatsPane()
	return true
end

--- Lowers the player's rank in given faction.
--- @param faction tes3faction
function this.demote(faction)
	if not faction.playerJoined or faction.playerExpelled then
		return
	end
	faction.playerRank = math.clamp(faction.playerRank - 1, 0, 9)
end

--- @param faction tes3faction
local function canPromote(faction)
	local nextRank = faction.playerRank + 1
	if faction:getRankName(nextRank) == ""
	or faction.playerRank == 9 then
		return false
	end
	return true
end

--- Increases the player's rank in given faction.
--- @param faction tes3faction
function this.promote(faction)
	if not faction.playerJoined or faction.playerExpelled then
		return
	end
	if not canPromote(faction) then
		tes3.messageBox(i18n("You reached top rank in this faction."))
		return
	end
	faction.playerRank = math.clamp(faction.playerRank + 1, 0, 9)
end

--- Teleports the player to given Cell or NPC.
--- @param destination tes3cell|tes3npc
function this.teleport(destination)
	local cell = destination
	local position
	if destination.objectType == tes3.objectType.npc then
		local npcRef = tes3.getReference(destination.id)
		cell = npcRef.cell
		position = npcRef.position
	end
	position = position or util.getTeleportPosition(cell)
	tes3.positionCell({
		cell = cell.isInterior and cell or { cell.gridX, cell.gridY },
		position = position,
	})
end

return this
