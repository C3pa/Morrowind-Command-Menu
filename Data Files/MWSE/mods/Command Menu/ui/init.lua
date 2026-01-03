local commands = require("Command Menu.commands")
local config = require("Command Menu.config")
local uiid = require("Command Menu.ui.uiid")
local uiUtil = require("Command Menu.ui.util")
local util = require("Command Menu.util")


local i18n = mwse.loadTranslations("Command Menu")
local log = mwse.Logger.new()
local menuID = tes3ui.registerID(uiid.menu)
local ui = {}


---@param container tes3uiElement
local function createGeneralTab(container)
	local pane = container:createVerticalScrollPane()
	pane.autoHeight = true
	pane.heightProportional = 1.0

	local contentsBlock = uiUtil.createTopBottomBlock(pane)

	do -- Engine settings category
		local container = uiUtil.createCategory(contentsBlock, i18n("Engine settings"))

		mwse.mcm.createOnOffButton(container, {
			label = i18n("God mode"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.worldController.menuController.godModeEnabled
				end,
				setter = function(self, newValue)
					commands.setGodMode(newValue)
				end,
			}),
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Collision"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return not tes3.worldController.menuController.collisionDisabled
				end,
				setter = function(self, newValue)
					commands.setCollsion(newValue)
				end
			})
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Vanity mode"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.getVanityMode()
				end,
				setter = function(self, newValue)
					commands.setVanityMode(newValue)
				end
			})
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("AI enabled"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return not tes3.worldController.menuController.aiDisabled
				end,
				setter = function(self, newValue)
					commands.setAI(newValue)
				end,
			})
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Fog of war on local map"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return not tes3.worldController.menuController.fogOfWarDisabled
				end,
				setter = function(self, newValue)
					commands.setFogOfWar(newValue)
				end
			})
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Wireframe mode"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.worldController.menuController.wireframeEnabled
				end,
				setter = function(self, newValue)
					commands.setWireframe(newValue)
				end
			})
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Draw cell borders"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.worldController.menuController.bordersEnabled
				end,
				setter = function(self, newValue)
					tes3.worldController.menuController.bordersEnabled = newValue
				end
			})
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Draw collision boxes"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.worldController.menuController.collisionBoxesEnabled
				end,
				setter = function(self, newValue)
					tes3.worldController.menuController.collisionBoxesEnabled = newValue
				end
			})
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Draw path grid nodes"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.worldController.menuController.pathGridShown
				end,
				setter = function(self, newValue)
					tes3.worldController.menuController.pathGridShown = newValue
				end
			})
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Teleportation spells enabled"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return not tes3.worldController.flagTeleportingDisabled
				end,
				--- @param newValue boolean
				setter = function(self, newValue)
					tes3.worldController.flagTeleportingDisabled = not newValue
				end
			})
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Levitation spells enabled"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return not tes3.worldController.flagLevitationDisabled
				end,
				--- @param newValue boolean
				setter = function(self, newValue)
					tes3.worldController.flagLevitationDisabled = not newValue
				end
			})
		})
	end

	do -- Mechanics
		local container = uiUtil.createCategory(contentsBlock, i18n("Mechanics"))

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Combat enabled"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "combatEnabled" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Rest interrupt enabled"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "restInterruptEnabled" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Essential actors can't be damaged"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "blockDamageForEssentialActors" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Always hit"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "alwaysHit" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Casting always succeeds"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "castingAlwaysSucceeds" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Spells don't consume magicka"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "spellsConsumeNoMagicka" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Enchantments don't consume charge"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "enchantmentsConsumeNoCharge" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Brewing potions always succeeds"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "potionBrewingAlwaysSucceeds" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Self-repairing equipment always succeeds"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "repairingAlwaysSucceeds" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Picking locks always succeeds"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "lockPickAlwaysSucceeds" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Player doesn't recieve Sun Damage as a Vampire"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "blockSunDamage" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Fatiguesless jumping"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "fatiguelessJumping" })
		})
	end

	do -- Security & Crime
		local container = uiUtil.createCategory(contentsBlock, i18n("Security & Crime"))

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Auto unlock doors and containers"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "unlockEnabled" })
		})

		local function getBountyLabel()
			local bounty = 0
			if tes3.mobilePlayer then
				bounty = tes3.mobilePlayer.bounty
			end
			return string.format(i18n("Current player bounty") .. " = %s.", bounty)
		end

		mwse.mcm.createButton(container, {
			label = getBountyLabel(),
			buttonText = i18n("Clear bounty"),
			postCreate = function(self)
				self.label = getBountyLabel()
				self.elements.label.text = getBountyLabel()
			end,
			callback = function(self)
				commands.clearBounty()
				self:postCreate()
			end
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Stealing owned items is not a crime"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "stealingFree" })
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Picking locks isn't considered a crime"),
			leftSide = true,
			variable = mwse.mcm.createTableVariable({ table = config, id = "lockPickNotCrime" })
		})

		mwse.mcm.createButton(container, {
			label = i18n("Clear stolen flag on items in player's inventory"),
			buttonText = i18n("Clear"),
			callback = function(self)
				commands.clearStolenFlag()
				tes3.messageBox(i18n("Stolen flag cleared."))
			end
		})
	end

	do -- Time & Weather
		local container = uiUtil.createCategory(contentsBlock, i18n("Time & Weather"))

		local weathers = {}
		for weather, id in pairs(tes3.weather) do
			table.insert(weathers, { label = i18n("weather." .. util.capitalize(weather)), value = id })
		end
		table.sort(weathers, function(a, b)
			return a.label < b.label
		end)

		mwse.mcm.createDropdown(container, {
			label = i18n("Change current weather:"),
			options = weathers,
			variable = mwse.mcm.createCustom({
				getter = function()
					return tes3.getCurrentWeather().index or 0
				end,
				setter = function(self, newVal)
					tes3.worldController.weatherController:switchImmediate(newVal)
				end
			})
		})

		mwse.mcm.createTextField(container, {
			label = i18n("Timescale"),
			-- TODO: might want to save the changes to timescale
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.worldController.timescale.value
				end,
				converter = tonumber,
				setter = function(self, newValue)
					tes3.worldController.timescale.value = newValue
				end,

			})
		})

		mwse.mcm.createSlider(container, {
			label = i18n("Simulation time scale"),
			min = 0.5,
			max = 2.0,
			jump = 0.01,
			decimalPlaces = 2,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.worldController.simulationTimeScalar
				end,
				setter = function(self, newValue)
					tes3.worldController.simulationTimeScalar = newValue
				end
			})
		})
	end

	do -- Misc
		local container = uiUtil.createCategory(contentsBlock, i18n("Misc"))

		local resetActors = container:createButton({
			text = i18n("Reset actors")
		})
		resetActors:registerAfter(tes3.uiEvent.mouseClick, function(e)
			commands.resetActors()
		end)

		local fixMe = container:createButton({
			text = i18n("Fix me")
		})
		fixMe:registerAfter(tes3.uiEvent.mouseClick, function(e)
			commands.fixMe()
		end)

		local killHostiles = container:createButton({
			text = i18n("Kill hostiles")
		})
		killHostiles:registerAfter(tes3.uiEvent.mouseClick, function(e)
			commands.killHostiles()
		end)

		local fillMap = container:createButton({
			text = i18n("Show all map markers")
		})
		fillMap:registerAfter(tes3.uiEvent.mouseClick, function(e)
			commands.fillMap()
		end)

		local fillJournal = container:createButton({
			text = i18n("Fill journal")
		})
		fillJournal:registerAfter(tes3.uiEvent.mouseClick, function(e)
			commands.fillJournal()
		end)

		local statsReview = container:createButton({
			text = i18n("Open stats review menu")
		})
		statsReview:registerAfter(tes3.uiEvent.mouseClick, function(e)
			commands.enableStatReviewMenu()
		end)

		local rechargePowers = container:createButton({
			text = i18n("Recharge player powers")
		})
		rechargePowers:registerAfter(tes3.uiEvent.mouseClick, function(e)
			commands.rechargePowers()
			tes3.messageBox(i18n("All powers recharged."))
		end)

		local removeMagic = container:createButton({
			text = i18n("Remove magic")
		})
		removeMagic:registerAfter(tes3.uiEvent.mouseClick, function(e)
			commands.removeMagic()
			tes3.messageBox(i18n("Removed all curses, diseases and spells."))
		end)

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Player can colide with other actors and projectiles?"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.mobilePlayer.mobToMobCollision
				end,
				setter = function(self, newValue)
					tes3.mobilePlayer.mobToMobCollision = newValue
				end,
			}),
		})

		mwse.mcm.createOnOffButton(container, {
			label = i18n("Player can colide with other objects?"),
			leftSide = true,
			variable = mwse.mcm.createCustom({
				getter = function(self)
					return tes3.mobilePlayer.movementCollision
				end,
				setter = function(self, newValue)
					tes3.mobilePlayer.movementCollision = newValue
				end,
			}),
		})
	end
end

---@param container tes3uiElement
local function createPlayerTab(container)
	local pane = uiUtil.createSearchPane(container, function(category, searchTerm, cleared)
		local contentsContainer = category:findChild("ContentsContainer")
		---@cast contentsContainer tes3uiElement
		for _, statBlock in ipairs(contentsContainer.children) do
			local labelBlock = statBlock:findChild("LabelBlock")
			---@cast labelBlock tes3uiElement
			local label = labelBlock.children[1]
			local statContainer = labelBlock.parent
			if cleared then
				statContainer.visible = true
			else
				if util.ciContains(label.text, searchTerm) then
					statContainer.visible = true
				else
					statContainer.visible = false
				end
			end
		end
	end, uiid.playerPane)

	uiUtil.recreatePlayerPane(pane)
end


---@param container tes3uiElement
local function createItemsTab(container)
	local count = mwse.mcm.createVariable({ value = 1 })
	local slider = mwse.mcm.createSlider(container, {
		label = i18n("No. items to add"),
		variable = count,
		min = 1,
		max = 10,
		jump = 1,
	})

	local pane = uiUtil.createSearchPane(container, uiUtil.standardFilterHidden)
	for _, object in ipairs(tes3.dataHandler.nonDynamicData.objects) do
		if not object.isCarriable then
			goto continue
		end
		---@cast object tes3item
		if util.isObjectDeprecated(object) then
			goto continue
		end
		local itemId = object.id
		local name = util.getNiceName(object)
		local iconPath = "icons\\" .. object.icon

		local select = pane:createTextSelect({ text = name })
		select:registerAfter(tes3.uiEvent.mouseClick, function(e)
			tes3.addItem({
				item = itemId,
				count = count.value,
				reference = tes3.player
			})
			tes3.messageBox(i18n("Added") .. " %d %q.", count.value, name)
		end)
		select:register(tes3.uiEvent.help, function(e)
			local tooltip = tes3ui.createTooltipMenu({ object = itemId })
			local border = uiUtil.createAutoSizedBlock(tooltip)
			border.childAlignX = 0.5
			border.borderAllSides = 8
			border.paddingAllSides = 8
			local icon = border:createImage({ path = iconPath })
			icon.imageScaleX = 2
			icon.imageScaleY = 2
			tooltip:updateLayout()
		end)
		select.visible = false

		::continue::
	end

	pane:getContentElement():sortChildren(function(a, b)
		return string.lower(a.text) < string.lower(b.text)
	end)
end

---@param container tes3uiElement
local function createSpellsTab(container)
	local pane = uiUtil.createSearchPane(container, uiUtil.standardFilterHidden)

	local spellTypeNames = table.invert(tes3.spellType)
	for i, name in pairs(spellTypeNames) do
		spellTypeNames[i] = util.capitalize(name)
	end
	local pts = tes3.findGMST(tes3.gmst.spoints).value --[[@as string]]

	for _, spell in ipairs(tes3.dataHandler.nonDynamicData.spells) do
		local spellId = spell.id
		local name = spell.name

		local select = pane:createTextSelect({
			text = string.format("%s, (%s, %d %s)",
				spell.name, i18n(spellTypeNames[spell.castType]), spell.magickaCost, pts)
		})
		select:registerAfter(tes3.uiEvent.mouseClick, function(e)
			tes3.playSound({ sound = "spellmake success" })
			tes3.addSpell({
				spell = spellId,
				reference = tes3.player,
			})
			tes3.messageBox(i18n("Learned") .. " %q.", name)
		end)
		select:register(tes3.uiEvent.help, function(e)
			tes3ui.createTooltipMenu({ spell = spellId })
		end)
		select.visible = false
	end

	pane:getContentElement():sortChildren(function(a, b)
		return string.lower(a.text) < string.lower(b.text)
	end)
end

-- There is some kind of layout issue where the soul gem preview isn't visible until first interaction on this tab.
---@param container tes3uiElement
---@param soulGems tes3misc[]
---@param creatures tes3creature[]
local function createSoulGemTab(container, soulGems, creatures)
	-- Let's take common soul gem as starting gem, because the first one is Azura's star.
	local startingGem = soulGems[2]
	local selectedGemVariable = mwse.mcm.createVariable({
		value = startingGem
	})

	local selectedSoulVariable = mwse.mcm.createVariable({
		value = util.getStartingCreature(creatures, startingGem)
	})

	--- @type mwseMCMDropdownOption[]
	local options = {}
	for _, soulGem in ipairs(soulGems) do
		table.insert(options, {
			label = soulGem.name,
			value = soulGem
		})
	end

	local topBlock = uiUtil.createLeftRightBlock(
		container, tes3ui.registerID("CommandMenu_soulGems_top_block_container"))
	topBlock.borderAllSides = 4

	local dropDown = mwse.mcm.createDropdown(topBlock, {
		label = i18n("Choose a Soul Gem:"),
		options = options,
		variable = selectedGemVariable,
	})

	local previewBlock = uiUtil.createLeftRightBlock(topBlock,
		tes3ui.registerID("CommandMenu_soulGems_top_block_previewContainer"))

	uiUtil.recreateSoulGemPreview(previewBlock, selectedGemVariable.value, selectedSoulVariable.value)
	-- Update currently selected soul gem preview
	dropDown.callback = function(self)
		selectedSoulVariable.value = util.getStartingCreature(creatures, selectedGemVariable.value)
		uiUtil.recreateSoulGemPreview(previewBlock, selectedGemVariable.value, selectedSoulVariable.value)
	end

	container:createLabel({
		text = i18n("Choose a Soul:"),
	})

	local pane = uiUtil.createSearchPane(container, uiUtil.standardFilterVisible)
	local pts = tes3.findGMST(tes3.gmst.spoints).value --[[@as string]]

	for _, creature in ipairs(creatures) do
		local select = pane:createTextSelect({
			text = string.format("%s, (%d %s)", util.getNiceName(creature), creature.soul, pts)
		})
		select:registerAfter(tes3.uiEvent.mouseClick, function(e)
			local maxSoul = selectedGemVariable.value.soulGemCapacity
			if creature.soul > maxSoul then
				tes3.messageBox(i18n("Too large soul"))
				return
			end
			selectedSoulVariable.value = creature
			uiUtil.recreateSoulGemPreview(previewBlock, selectedGemVariable.value, selectedSoulVariable.value)
			select:getTopLevelMenu():updateLayout()
		end)
	end
end


---@param npcId string
---@param name string
local function openTeleportMenuNPC(npcId, name)
	tes3ui.showMessageMenu({
		header = i18n("Do you wish to teleport to the NPC's location or teleport the NPC in front of yourself?"),
		buttons = {
			{
				text = string.format(i18n("Teleport %s here"), name),
				callback = function()
					commands.teleportNPC(npcId)
				end,
			}, {
			text = string.format(i18n("Teleport to %s's location"), name),
			callback = function()
				ui.closeMenu()
				commands.teleportToNpc(npcId)
			end
		}
		},
		cancels = true
	})
end

---@param container tes3uiElement
---@param npcs tes3npc[]
local function createTeleportTab(container, npcs)
	local current = mwse.mcm.createVariable({ value = 1 })

	local dropDown = mwse.mcm.createDropdown(container, {
		label = i18n("Teleport to..."),
		options = {
			{ label = i18n("Cell"), value = 1 },
			{ label = i18n("NPC"),  value = 2 },
		},
		variable = current,
		callback = function(self)
			local cell = container:findChild("CommandMenu_teleport_cell_container") --[[@as tes3uiElement]]
			local NPC = container:findChild("CommandMenu_teleport_npc_container") --[[@as tes3uiElement]]
			if current.value == 1 then
				uiUtil.showTab(cell)
				uiUtil.hideTab(NPC)
			else
				uiUtil.hideTab(cell)
				uiUtil.showTab(NPC)
			end
		end
	})

	local cellContainer = uiUtil.createTabContainer(container,
		tes3ui.registerID("CommandMenu_teleport_cell_container"))
	-- This is the default view in teleport tab.
	cellContainer.visible = true

	-- Teleport to Cell
	local cellPane = uiUtil.createSearchPane(cellContainer, uiUtil.standardFilterVisible)
	for _, cell in ipairs(tes3.dataHandler.nonDynamicData.cells) do
		local select = cellPane:createTextSelect({ text = cell.editorName })
		local id = cell.id
		local gridX = cell.gridX
		local gridY = cell.gridY
		select:registerAfter(tes3.uiEvent.mouseClick, function(e)
			ui.closeMenu()
			commands.teleportToCell({ id = id, x = gridX, y = gridY })
		end)
	end

	cellPane:getContentElement():sortChildren(function(a, b)
		return string.lower(a.text) < string.lower(b.text)
	end)

	-- Teleport to NPC
	local npcContainer = uiUtil.createTabContainer(container,
		tes3ui.registerID("CommandMenu_teleport_npc_container"))
	local npcPane = uiUtil.createSearchPane(npcContainer, uiUtil.standardFilterVisible)
	local idFormat = i18n("Id") .. ": %q"
	local locationFormat = i18n("Located at") .. ": %s"
	local deadFormat = i18n("Dead") .. ": %s"

	for _, npc in ipairs(tes3.dataHandler.nonDynamicData.objects) do
		if not util.isValidNpc(npc) then
			goto continue
		end
		---@cast npc tes3npc
		if util.isObjectDeprecated(npc) then
			goto continue
		end
		local npcId = npc.id
		local name = util.getNiceName(npc)
		local select = npcPane:createTextSelect({ text = name })
		select:registerAfter(tes3.uiEvent.mouseClick, function()
			openTeleportMenuNPC(npcId, name)
		end)
		select:register(tes3.uiEvent.help, function(e)
			local npcRef = tes3.getReference(npcId)
			local tooltip = tes3ui.createTooltipMenu({ object = npcRef.object })
			local bodyBlock = uiUtil.createTopBottomBlock(tooltip)
			bodyBlock.childAlignX = 0
			bodyBlock.paddingAllSides = 8
			bodyBlock:createLabel({ text = string.format(idFormat, npcRef.id) })
			bodyBlock:createLabel({ text = string.format(locationFormat, npcRef.cell.editorName) })
			bodyBlock:createLabel({
				text = string.format(deadFormat,
					npcRef.isDead and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value)
			})
		end)
		::continue::
	end
	npcPane:getContentElement():sortChildren(function(a, b)
		return string.lower(a.text) < string.lower(b.text)
	end)
end


---@param container tes3uiElement
---@param factions tes3faction[]
local function createFactionsTab(container, factions)
	local pane = uiUtil.createSearchPane(container, function(category, searchTerm, cleared)
		local label = category:findChild("CategoryLabel")
		--- @cast label tes3uiElement
		if cleared then
			category.visible = true
		else
			if util.ciContains(label.text, searchTerm) then
				category.visible = true
			else
				category.visible = false
			end
		end
	end)

	for _, faction in ipairs(factions) do
		local entryContainer = uiUtil.createCategory(pane, util.getNiceName(faction))
		local label = entryContainer:createLabel({ text = util.getFactionLabel(faction) })
		local buttonsBlock = uiUtil.createLeftRightBlock(entryContainer)
		buttonsBlock.borderAllSides = 4

		local join = buttonsBlock:createButton({
			text = faction.playerJoined and i18n("Leave") or i18n("Join"),
		})
		join:registerAfter(tes3.uiEvent.mouseClick, function(e)
			if faction.playerJoined then
				faction:leave()
				label.text = util.getFactionLabel(faction)
				join.text = i18n("Join")
				return
			end
			faction:join()
			label.text = util.getFactionLabel(faction)
			join.text = i18n("Leave")
		end)

		local demote = buttonsBlock:createButton({
			text = i18n("Demote"),
		})
		demote:registerAfter(tes3.uiEvent.mouseClick, function(e)
			faction:demote()
			label.text = util.getFactionLabel(faction)
		end)

		local promote = buttonsBlock:createButton({
			text = i18n("Promote"),
		})
		promote:registerAfter(tes3.uiEvent.mouseClick, function(e)
			faction:promote()
			label.text = util.getFactionLabel(faction)
		end)

		local expel = buttonsBlock:createButton({
			text = faction.playerExpelled and i18n("Rejoin") or i18n("Expel")
		})
		expel:registerAfter(tes3.uiEvent.mouseClick, function(e)
			if not faction.playerJoined then return end
			if faction.playerExpelled then
				faction:clearExpel()
				expel.text = i18n("Expel")
				label.text = util.getFactionLabel(faction)
				return
			end
			faction:expel()
			expel.text = i18n("Rejoin")
			label.text = util.getFactionLabel(faction)
		end)
	end
end

---@param container tes3uiElement
local function createQuestsTab(container)
	local currentQuest = tes3.worldController.quests[1]
	local label = container:createLabel({ text = i18n("Choose a quest...") })
	label.color = tes3ui.getPalette(tes3.palette.headerColor)

	local questsPane = uiUtil.createSearchPane(container, uiUtil.standardFilterVisible)
	questsPane.heightProportional = 2 / 3

	local currentContainer = container:createThinBorder({
		id = tes3ui.registerID(
			"CommandMenu_quests_current_container")
	})
	currentContainer.autoHeight = true
	currentContainer.autoWidth = true
	currentContainer.widthProportional = 1.0
	currentContainer.heightProportional = 4 / 3
	currentContainer.flowDirection = tes3.flowDirection.topToBottom
	currentContainer.paddingAllSides = 2

	for _, quest in ipairs(tes3.worldController.quests) do
		local select = questsPane:createTextSelect({ text = quest.id })
		select:registerAfter(tes3.uiEvent.mouseClick, function(e)
			currentQuest = quest
			uiUtil.recreateQuestInfosList(currentContainer, currentQuest)
		end)
	end

	uiUtil.recreateQuestInfosList(currentContainer, currentQuest)
end


--- @param objects CommandMenu.objectsTable
function ui.createMenu(objects)
	local menuElements = uiUtil.createHeadingMenu({
		heading = i18n("Choose items to add"),
		id = menuID,
		minWidth = 500,
		minHeight = 800,
	})

	local menu = menuElements.body

	local tabsButtonsContainer = uiUtil.createLeftRightBlock(menu)
	menu:createDivider()

	--- @type table<string, tes3uiElement>
	local tabs = {}
	tabs.generalContainer = uiUtil.createTabContainer(menu, tes3ui.registerID("CommandMenu_general_container"))
	createGeneralTab(tabs.generalContainer)

	tabs.playerContainer = uiUtil.createTabContainer(menu, tes3ui.registerID("CommandMenu_player_container"))
	createPlayerTab(tabs.playerContainer)

	tabs.itemsContainer = uiUtil.createTabContainer(menu, tes3ui.registerID("CommandMenu_items_container"))
	createItemsTab(tabs.itemsContainer)

	tabs.spellsContainer = uiUtil.createTabContainer(menu, tes3ui.registerID("CommandMenu_spells_container"))
	createSpellsTab(tabs.spellsContainer)

	tabs.soulGemsContainer = uiUtil.createTabContainer(menu, tes3ui.registerID("CommandMenu_soulGem_container"))
	createSoulGemTab(tabs.soulGemsContainer, objects.soulGems, objects.creatures)

	tabs.teleportContainer = uiUtil.createTabContainer(menu, tes3ui.registerID("CommandMenu_teleport_container"))
	createTeleportTab(tabs.teleportContainer, objects.npcs)

	tabs.factionsContainer = uiUtil.createTabContainer(menu, tes3ui.registerID("CommandMenu_factions_container"))
	createFactionsTab(tabs.factionsContainer, objects.factions)

	tabs.questsContainer = uiUtil.createTabContainer(menu, tes3ui.registerID("CommandMenu_quests_container"))
	createQuestsTab(tabs.questsContainer)

	-- Done button
	local doneContainer = uiUtil.createLeftRightBlock(menu, tes3ui.registerID("CommandMenu_done_container"))
	doneContainer.childAlignX = 1.0

	local done = doneContainer:createButton({
		id = tes3ui.registerID(uiid.doneButton),
		text = tes3.findGMST(tes3.gmst.sClose).value --[[@as string]]
	})
	done:registerAfter(tes3.uiEvent.mouseClick, ui.closeMenu)

	-- Create Tab buttons
	local firstButton = uiUtil.createTabButton(tabsButtonsContainer, i18n("General"), tabs, "generalContainer",
		i18n("General"))
	uiUtil.createTabButton(tabsButtonsContainer, i18n("Player"), tabs, "playerContainer", i18n("Player stats"))
	uiUtil.createTabButton(tabsButtonsContainer, i18n("Items"), tabs, "itemsContainer", i18n("Choose items to add"))
	uiUtil.createTabButton(tabsButtonsContainer, i18n("Spells"), tabs, "spellsContainer", i18n("Choose spells to learn"))
	uiUtil.createTabButton(tabsButtonsContainer, i18n("Soul Gems"), tabs, "soulGemsContainer",
		i18n("Choose a soul gem to add"))
	uiUtil.createTabButton(tabsButtonsContainer, i18n("Teleport"), tabs, "teleportContainer", i18n("Teleport"))
	uiUtil.createTabButton(tabsButtonsContainer, i18n("Factions"), tabs, "factionsContainer",
		i18n("Manage faction membership"))
	uiUtil.createTabButton(tabsButtonsContainer, i18n("Quests"), tabs, "questsContainer", i18n("Quests"))

	-- Show the first tab.
	firstButton:triggerEvent(tes3.uiEvent.mouseClick)
	menu:getTopLevelMenu():updateLayout()
	menuElements.menu.visible = false
	return { menu = menuElements.menu }
end

function ui.isMenuOpen()
	if not tes3.menuMode() then
		return false
	end
	local menu = tes3ui.findMenu(menuID)
	if not menu then
		return false
	end
	return menu.visible
end

function ui.openMenu()
	if tes3.onMainMenu() then
		tes3.messageBox(i18n("Load a game to open Command Menu."))
		return
	end
	if ui.isMenuOpen() then return end
	local menu = tes3ui.findMenu(menuID)
	if not menu then
		log:warn("Command Menu not found.")
		tes3.messageBox("Command Menu not found.")
		return
	end

	-- Update the player page with current attribute/skill values.
	local playerPane = menu:findChild(uiid.playerPane)
	---	@cast playerPane tes3uiElement
	uiUtil.recreatePlayerPane(playerPane)
	menu.visible = true
	tes3ui.enterMenuMode(menuID)
end

function ui.closeMenu()
	local menu = tes3ui.findMenu(menuID)
	if not menu then return end
	mwse.saveConfig(config.fileName, config)
	menu.visible = false
	tes3ui.leaveMenuMode()
end

return ui
