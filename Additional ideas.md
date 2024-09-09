- Additional ideas:
 - Other console commands:
  - https://en.uesp.net/wiki/Morrowind:Console
  - https://en.uesp.net/wiki/Morrowind_Mod:Categorical_Function_List#Console
  - https://en.uesp.net/morrow/editor/mw_cscommands.shtml
 - Might want to add keybinds to some functions of the menu.
 - Big features:
  - Add a tab for global variables. Note: tes3.dataHandler.nonDynamicData.globals can't be iterated over with pairs
  - Spawn creature/NPC tab. Something similar to Axemagister's test menu.
 - Tweaking faction reputation
 - Player:
  - Tweaking reputation
  - Water walking, flying toggles
  - isAffectedByGravity
  - mobToMobCollision
  - movementCollision
  - Open a barter menu with a bartender with (almost) infinite gold.
  - Clear magic (all) - https://mwse.github.io/MWSE/apis/tes3/#tes3removeeffects
  - Cure all diseases and restore all damaged attributes and skills.
  - Inifinite torch -> add a torch that won't burn out.
  - Add a command that allows sleeping (and optionally kills enemies that are blocking sleep).
  - Open Inventory select menu (or showContentsMenu) to take items from the target for free
  - Infinite oxygen while diving?: https://mwse.github.io/MWSE/types/tes3mobilePlayer/?h=bounty#holdbreathtime
  - Disable encumbrance?
  - Unlimited fatigue?
  - Add buttons to cast almsivi/divine intervention/recall/mark
  - Kill stats editor: using tes3.decrementKillCount, tes3.getKillCount, tes3.getKillCounts, tes3.incrementKillCount, tes3.setKillCount
  - There are also kill commands when the player is werewolf: tes3.setWerewolfKillCount
  - tes3.setPlayerControlState

 - Disable tooltips: tes3ui.suppressTooltip
 - Other fields on https://mwse.github.io/MWSE/types/tes3uiMenuController/
 - Faders
  - Disable blindness fader - tes3.worldController.blindnessFader
  - Disable damage fader - tes3.worldController.hitFader, werewolf fader
 - Gravity - tes3.worldController.mobController.gravity
 - terminalVelocity - tes3.worldController.mobController.terminalVelocity
 - Respawn organic containers - maybe we can set tes3.worldController.monthsToRespawn to 0
 - Time:
  - tes3.advanceTime
  - tes3.worldController.year and other time related variables
 - Mechanics:
  - Try blocking detection while sneaking:
```lua
-- @param e detectSneakEventData
event.register(tes3.event.detectSneak, function(e)
	if not config.blockDetection then return end
	e.isDetected = false
end)
```

