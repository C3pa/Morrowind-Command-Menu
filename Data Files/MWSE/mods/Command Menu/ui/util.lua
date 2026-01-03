local uiid = require("Command Menu.ui.uiid")
local util = require("Command Menu.util")


local i18n = mwse.loadTranslations("Command Menu")

local uiUtil = {}

--- @param tab tes3uiElement
function uiUtil.hideTab(tab)
	tab.visible = false
	tab.autoHeight = false
	tab.autoWidth = false
	tab.height = 0
	tab.width = 0
end

--- @param tab tes3uiElement
function uiUtil.showTab(tab)
	tab.visible = true
	tab.autoHeight = true
	tab.autoWidth = true
end

---@param parent tes3uiElement
---@param id string|integer|nil
function uiUtil.createAutoSizedBlock(parent, id)
	local block = parent:createBlock({ id = id })
	block.autoHeight = true
	block.autoWidth = true
	block.widthProportional = 1.0
	return block
end

--- @param parent tes3uiElement
--- @param id string|integer|nil
function uiUtil.createLeftRightBlock(parent, id)
	local block = uiUtil.createAutoSizedBlock(parent, id)
	block.flowDirection = tes3.flowDirection.leftToRight
	return block
end

--- @param parent tes3uiElement
--- @param id string|integer|nil
function uiUtil.createTopBottomBlock(parent, id)
	local block = uiUtil.createAutoSizedBlock(parent, id)
	block.flowDirection = tes3.flowDirection.topToBottom
	return block
end

--- @param parent tes3uiElement
--- @param id string|integer|nil
function uiUtil.createTabContainer(parent, id)
	local tabContainer = uiUtil.createTopBottomBlock(parent, id)
	tabContainer.borderLeft = 4
	tabContainer.borderRight = 4
	tabContainer.heightProportional = 1.0
	tabContainer.visible = false

	return tabContainer
end

--- @param container tes3uiElement The UI element in which the new button will be created.
--- @param buttonText string The text on the new button.
--- @param tabs table<string, tes3uiElement> A map of tab containers.
--- @param currentTabKey string A key in `tabs` of a tab that will be made visible when the created button is clicked.
--- @param newTitle string The new title text.
--- @return tes3uiElement button
function uiUtil.createTabButton(container, buttonText, tabs, currentTabKey, newTitle)
	local button = container:createButton({
		id = tes3ui.registerID("CommandMenu_button_" .. buttonText),
		text = buttonText,
	})
	local titleLabel = container:getTopLevelMenu():findChild(uiid.heading)
	button:registerAfter(tes3.uiEvent.mouseClick, function(e)
		-- Hide all the tabs and show the selected tab.
		for _, tab in pairs(tabs) do
			uiUtil.hideTab(tab)
		end
		uiUtil.showTab(tabs[currentTabKey])
		titleLabel.text = newTitle
		container:getTopLevelMenu():updateLayout()
	end)
	return button
end

--- @param parent tes3uiElement
--- @param labelText string
function uiUtil.createCategory(parent, labelText)
	local outerContainer = uiUtil.createTopBottomBlock(parent)
	outerContainer.paddingAllSides = 4
	local label = outerContainer:createLabel({ id = tes3ui.registerID("CategoryLabel"), text = labelText })
	label.color = tes3ui.getPalette(tes3.palette.headerColor)

	local container = uiUtil.createTopBottomBlock(outerContainer, tes3ui.registerID("ContentsContainer"))
	container.borderLeft = 8
	container.borderTop = 8
	return container, label
end

--- @param previewBlock tes3uiElement
--- @param currentSoulGem tes3misc
--- @param currentCreature tes3creature
function uiUtil.recreateSoulGemPreview(previewBlock, currentSoulGem, currentCreature)
	previewBlock:destroyChildren()

	local grow = previewBlock:createBlock()
	grow.autoHeight = true
	grow.autoWidth = true
	grow.widthProportional = 0.5

	-- Create icon
	local icon = previewBlock:createImage({
		path = "icons\\" .. currentSoulGem.icon
	})
	icon.imageScaleX = 2
	icon.imageScaleY = 2
	icon.borderLeft = 8
	icon.borderRight = 16

	-- Create labels
	local labelsBlock = previewBlock:createBlock()
	labelsBlock.autoHeight = true
	labelsBlock.autoWidth = true
	labelsBlock.flowDirection = tes3.flowDirection.topToBottom

	local nameLabel = labelsBlock:createLabel({
		text = currentSoulGem.name
	})

	local soulLabel = labelsBlock:createLabel({
		text = string.format("%s (%d/%d)",
			currentCreature.name,
			currentCreature.soul,
			currentSoulGem.soulGemCapacity
		)
	})
	soulLabel.color = tes3ui.getPalette(tes3.palette.headerColor)

	local addButton = labelsBlock:createButton({ text = i18n("Add") })
	addButton.borderTop = 12
	addButton:registerAfter(tes3.uiEvent.mouseClick, function(e)
		tes3.addItem({
			item = currentSoulGem,
			soul = currentCreature,
			count = 1,
			reference = tes3.player,
		})
		tes3.messageBox(i18n("Added") .. " %s (%s).", currentSoulGem.name, currentCreature.name)
	end)

	previewBlock:getTopLevelMenu():updateLayout()
end

---@param container tes3uiElement
function uiUtil.recreatePlayerPane(container)
	container:getContentElement():destroyChildren()

	local primaryAttributesCategory = uiUtil.createCategory(container, i18n("Primary Attributes"))
	for key, id in pairs(tes3.attribute) do
		-- This function gets names from GMSTs which are capitalized.
		local name = tes3.getAttributeName(id)
		local input = mwse.mcm.createTextField(primaryAttributesCategory, {
			label = name,
			variable = mwse.mcm.createCustom({
				converter = tonumber,
				getter = function(self)
					return tes3.mobilePlayer[key].current
				end,
				setter = function(self, newValue)
					if not newValue then return end
					local msg = string.format(i18n("Set x to y"), name, newValue)
					tes3.messageBox({ message = msg, duration = 3 })
					tes3.setStatistic({ reference = tes3.player, attribute = id, value = newValue })
				end
			})
		})
		-- We don't want default messagebox.
		--- @diagnostic disable-next-line: duplicate-set-field
		input.callback = function() end
	end


	local derivedAttributesCategory = uiUtil.createCategory(container, i18n("Derived Attributes"))
	local derivedKeys = { "health", "magicka", "fatigue", "encumbrance" }
	for _, key in ipairs(derivedKeys) do
		local name = util.capitalize(i18n(key))
		local input = mwse.mcm.createTextField(derivedAttributesCategory, {
			label = name,
			variable = mwse.mcm.createCustom({
				converter = tonumber,
				getter = function(self)
					return math.round(tes3.mobilePlayer[key].current, 2)
				end,
				setter = function(self, newValue)
					if not newValue then return end
					local msg = string.format(i18n("Set x to y"), name, newValue)
					tes3.messageBox({ message = msg, duration = 3 })
					tes3.setStatistic({ reference = tes3.player, name = key, value = newValue })
				end
			})
		})
		-- We don't want default messagebox.
		--- @diagnostic disable-next-line: duplicate-set-field
		input.callback = function() end
	end

	local skillsContainer = uiUtil.createCategory(container, i18n("Skills"))
	for key, id in pairs(tes3.skill) do
		-- This function gets names from GMSTs which are capitalized.
		local name = tes3.getSkillName(id)
		local input = mwse.mcm.createTextField(skillsContainer, {
			label = name,
			inGameOnly = true,
			variable = mwse.mcm.createCustom({
				converter = tonumber,
				getter = function(self)
					return tes3.mobilePlayer[key].current
				end,
				setter = function(self, newValue)
					if not newValue then return end
					local msg = string.format(i18n("Set x to y"), name, newValue)
					tes3.messageBox({ message = msg, duration = 3 })
					tes3.setStatistic({ reference = tes3.player, skill = id, value = newValue })
				end
			})
		})
		-- We don't want default messagebox.
		--- @diagnostic disable-next-line: duplicate-set-field
		input.callback = function() end
	end
end

--- @param parent tes3uiElement
--- @return tes3uiElement input
function uiUtil.createSeachBox(parent)
	local searchBox = parent:createThinBorder({ id = tes3ui.registerID("CommandMenu_search_border") })
	searchBox.autoHeight = true
	searchBox.autoWidth = true
	searchBox.widthProportional = 1.0
	searchBox.paddingAllSides = 8
	searchBox.borderBottom = 8
	searchBox.borderTop = 8

	local input = searchBox:createTextInput({
		id = tes3ui.registerID("CommandMenu_search_input"),
		autoFocus = true,
		placeholderText = i18n("Search..."),
	})
	input.autoWidth = true
	input.widthProportional = 1.0
	return input
end

-- TODO: consider limiting the number of search results to, for example 1000 items.

--- This filter makes all the child items visible when there is no text in the search box.
--- @param paneItem tes3uiElement
--- @param searchTerm string
--- @param cleared boolean
function uiUtil.standardFilterVisible(paneItem, searchTerm, cleared)
	if cleared or util.ciContains(paneItem.text, searchTerm) then
		paneItem.visible = true
		return
	end

	paneItem.visible = false
end

--- This filter makes all the child items hidden when there is no text in the search box.
--- @param paneItem tes3uiElement
--- @param searchTerm string
--- @param cleared boolean
function uiUtil.standardFilterHidden(paneItem, searchTerm, cleared)
	if not cleared and util.ciContains(paneItem.text, searchTerm) then
		paneItem.visible = true
		return
	end

	paneItem.visible = false
end

-- TODO: fix searching on player tab. When typing some search term and then clearing the search text,
-- all the settings are hidden
--- @param parent tes3uiElement
--- Function called on each pane item. It should hide and show pane children that match given searchTerm
--- (which is lowercase). Cleared is true when the search box text was cleared.
--- @param filter fun(paneItem: tes3uiElement, searchTerm: string, cleared: boolean)
--- @param id string|integer|nil The id of the pane element.
function uiUtil.createSearchPane(parent, filter, id)
	local input = uiUtil.createSeachBox(parent)
	local pane = parent:createVerticalScrollPane({ id = id })
	pane.autoHeight = true
	pane.heightProportional = 1.0

	--- @param e tes3uiEventData
	local function filterItems(e)
		local container = pane:getContentElement()
		local searchTerm = input.text:lower()
		local cleared = input.text == input:getLuaData("placeholderText")
		for _, paneItem in ipairs(container.children) do
			filter(paneItem, searchTerm, cleared)
		end
		pane:getTopLevelMenu():updateLayout()
		local widget = pane.widget --[[@as tes3uiScrollPane]]
		widget:contentsChanged()
	end
	input:registerAfter(tes3.uiEvent.textCleared, filterItems)
	input:registerAfter(tes3.uiEvent.textUpdated, filterItems)

	return pane
end


--- @class CommandMenu.ui.createHeadingMenu.params
--- @field id string|integer|nil
--- @field minWidth integer?
--- @field minHeight integer?
--- @field heading string
--- @field absolutePosAlignX number?
--- @field absolutePosAlignY number?

--- @param params CommandMenu.ui.createHeadingMenu.params
function uiUtil.createHeadingMenu(params)
	local menu = tes3ui.createMenu({ id = params.id, fixedFrame = true })

	menu.absolutePosAlignX = params.absolutePosAlignX or 0.1
	menu.absolutePosAlignY = params.absolutePosAlignY or 0.2
	menu.childAlignX = 0.5
	menu.childAlignY = 0.5
	menu.autoWidth = true
	menu.autoHeight = true
	menu.minWidth = params.minWidth or 500
	menu.minHeight = params.minHeight
	menu.alpha = tes3.worldController.menuAlpha

	-- Heading
	local headingBlock = uiUtil.createTopBottomBlock(menu)
	headingBlock.childAlignX = 0.5
	headingBlock.paddingAllSides = 8

	local title = headingBlock:createLabel({
		id = tes3ui.registerID(uiid.heading),
		text = params.heading
	})
	headingBlock:createDivider()

	-- Main body
	local bodyBlock = uiUtil.createTopBottomBlock(menu)
	bodyBlock.heightProportional = 1.0
	bodyBlock.paddingLeft = 8
	bodyBlock.paddingRight = 8

	menu:getTopLevelMenu():updateLayout()

	return {
		title = title,
		menu = menu,
		body = bodyBlock
	}
end

--- Some super duper secret agent code from Hrnchamd aimed to fix an issue with text label overlapping.
--- @param menu tes3uiElement
local function updateLayoutTextWrapping(menu)
	--- @param element tes3uiElement
	local function recurse(element)
		if element.contentType == tes3.contentType.text then
			-- Flag element to reflow content
			if element.wrapText then
				element.wrapText = true
				return
			end
		end
		for _, child in pairs(element.children) do
			if child then
				updateLayoutTextWrapping(child)
				-- As originally suggested by Hrnchamd. Doesn't fix the issue unfortunately.
				-- recurse(child)
			end
		end
	end

	menu:updateLayout()
	recurse(menu)
	menu:updateLayout()
end

--- @param dialogueParam tes3dialogue
local function getCurrentIndexText(dialogueParam)
	return string.format("%s: %s",
		i18n("Current journal index"),
		tes3.getJournalIndex({ id = dialogueParam })
	)
end

--- @param container tes3uiElement
--- @param quest tes3quest
function uiUtil.recreateQuestInfosList(container, quest)
	container:destroyChildren()
	local dialogue = quest.dialogue[1]
	local topContainer = uiUtil.createTopBottomBlock(container)
	topContainer.paddingAllSides = 8
	local label = topContainer:createLabel({
		text = string.format("%s: %s (%q)", i18n("Selected quest"), quest.id, dialogue.id)
	})
	label.color = tes3ui.getPalette(tes3.palette.bigNormalColor)

	local currentIndex = topContainer:createLabel({
		text = getCurrentIndexText(dialogue)
	})

	local infosPane = uiUtil.createSearchPane(container, function(paneItem, searchTerm, cleared)
		if cleared then
			paneItem.visible = true
			return
		end
		local categoryLabel = paneItem.children[1]
		if not categoryLabel then
			return
		end
		if util.ciContains(categoryLabel.text, searchTerm) then
			paneItem.visible = true
			return
		end
		local journalIndex = paneItem.children[2].children[1]
		if util.ciContains(journalIndex.text, searchTerm) then
			paneItem.visible = true
			return
		end
		paneItem.visible = false
	end)

	local len = #dialogue.info
	for i, info in ipairs(dialogue.info) do
		-- Text has '@' and '#' characters arount topic links. Remove them
		local infoText = string.gsub(string.gsub(info.text, "@", ""), "#", "")
		local categoryContainer, text = uiUtil.createCategory(infosPane, infoText)
		categoryContainer.consumeMouseEvents = false
		text.color = tes3ui.getPalette(tes3.palette.normalColor)
		text.consumeMouseEvents = false
		text.wrapText = true

		local journalIndex = categoryContainer:createLabel({
			text = string.format("%s: %d, %s: %s, %s: %s, %s: %s.",
				i18n("Journal index"), info.journalIndex,
				i18n("Quest name"), info.isQuestName,
				i18n("Finished"), info.isQuestFinished,
				i18n("Restart"), info.isQuestRestart
			)
		})
		journalIndex.consumeMouseEvents = false
		journalIndex.color = tes3ui.getPalette(tes3.palette.miscColor)

		local lastEntry = i == len
		if not lastEntry then
			infosPane:createDivider()
		end
		local outerContainer = categoryContainer.parent
		outerContainer:registerAfter(tes3.uiEvent.mouseOver, function(e)
			text.color = tes3ui.getPalette(tes3.palette.activeOverColor)
			text:getTopLevelMenu():updateLayout()
		end)
		outerContainer:registerAfter(tes3.uiEvent.mouseLeave, function(e)
			text.color = tes3ui.getPalette(tes3.palette.normalColor)
			text:getTopLevelMenu():updateLayout()
		end)
		outerContainer:register(tes3.uiEvent.mouseDown, function(e)
			text.color = tes3ui.getPalette(tes3.palette.activePressedColor)
			text:getTopLevelMenu():updateLayout()
		end)
		outerContainer:register(tes3.uiEvent.mouseRelease, function(e)
			text.color = tes3ui.getPalette(tes3.palette.activeOverColor)
			text:getTopLevelMenu():updateLayout()
		end)
		outerContainer:registerAfter(tes3.uiEvent.mouseClick, function(e)
			if info.journalIndex == 0 then return end
			dialogue:addToJournal({
				index = info.journalIndex
			})

			tes3.setJournalIndex({
				id = dialogue,
				index = info.journalIndex,
				showMessage = true,
			})
			currentIndex.text = getCurrentIndexText(dialogue)
		end)
	end
	updateLayoutTextWrapping(infosPane:getTopLevelMenu())
end

return uiUtil
