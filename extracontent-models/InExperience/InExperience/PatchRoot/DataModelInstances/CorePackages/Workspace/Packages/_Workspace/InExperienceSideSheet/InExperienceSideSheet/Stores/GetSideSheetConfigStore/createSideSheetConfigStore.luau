local GuiService = game:GetService("GuiService")

local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent

local Signals = require(parent.Signals)

local defineFastInt = game:DefineFastInt("MaxIGMBackgroundTransparencyPercent", 30)

local function createSideSheetConfigStore()
	local signal, v = Signals.createSignal(0)
	local signal2, setSideSheetDrawerWidth = Signals.createSignal(0)
	local signal3, setIsPeoplePageOpen = Signals.createSignal(false)
	local signal4, setDidSideSheetOpenWithPeoplePage = Signals.createSignal(false)

	local function updateBackgroundTransparency() -- 2 equivalent calls inferred from this helper
		return v(GuiService.PreferredTransparency * defineFastInt / 100)
	end

	updateBackgroundTransparency() -- inferred equivalent call
	local preferredTransparencyChangedConnection = GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		updateBackgroundTransparency() -- inferred equivalent call
	end)

	return {
		getBackgroundTransparency = signal,
		getSideSheetDrawerWidth = signal2,
		setSideSheetDrawerWidth = setSideSheetDrawerWidth,
		getIsPeoplePageOpen = signal3,
		setIsPeoplePageOpen = setIsPeoplePageOpen,
		getDidSideSheetOpenWithPeoplePage = signal4,
		setDidSideSheetOpenWithPeoplePage = setDidSideSheetOpenWithPeoplePage,
		cleanUp = function()
			preferredTransparencyChangedConnection:Disconnect()
		end
	}
end

return createSideSheetConfigStore
