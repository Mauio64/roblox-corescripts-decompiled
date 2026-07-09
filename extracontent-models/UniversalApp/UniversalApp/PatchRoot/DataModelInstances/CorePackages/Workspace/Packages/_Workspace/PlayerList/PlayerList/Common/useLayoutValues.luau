local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Display = require(ParentParentParent.Display)
local Cryo = require(ParentParentParent.Cryo)
local Foundation = require(ParentParentParent.Foundation)
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local LayoutValuesContext = require(script.Parent.LayoutValuesContext)
local FFlagEnableMobilePlayerListOnConsole = require(ParentParent.Flags.FFlagEnableMobilePlayerListOnConsole)
local FFlagPlayerListDropDownShowPlatformName = require(ParentParent.Flags.FFlagPlayerListDropDownShowPlatformName)

local function useLayoutValues() -- line: 21
	-- upvalues: React (copy), LayoutValuesContext (copy), useTokens (copy), FFlagEnableMobilePlayerListOnConsole (copy), useScaledValue (copy), SignalsReact (copy), Display (copy), FFlagPlayerListDropDownShowPlatformName (copy), Cryo (copy)
	local v14 = React.useContext(LayoutValuesContext)
	local v15 = useTokens()
	local v16 = if not FFlagEnableMobilePlayerListOnConsole then nil else useScaledValue(v14.PlayerDropDownSizeX * 10) / 10
	local v17 = if not FFlagEnableMobilePlayerListOnConsole then nil else useScaledValue((v14.EntryBaseSizeX or 150) * 10) / 10
	local v18 = if not FFlagEnableMobilePlayerListOnConsole then nil else useScaledValue(v14.PlayerDropDownSizeXMobile * 10) / 10
	local v19 = if not FFlagEnableMobilePlayerListOnConsole then nil else useScaledValue(v14.PlayerNameSizeXMobile * 10) / 10
	local v20 = if not FFlagEnableMobilePlayerListOnConsole then nil else useScaledValue(500)
	local v21 = if not FFlagEnableMobilePlayerListOnConsole then nil else useScaledValue(600)
	local v22 = if FFlagEnableMobilePlayerListOnConsole then nil else SignalsReact.useSignalState(Display.GetDisplayStore)
	local v23 = if FFlagEnableMobilePlayerListOnConsole then nil else SignalsReact.useSignalState(v22.getUIScale)
	local Size_100 = v15.Size.Size_100
	local t1 = {
		PlayerListSizeMin = v20,
		PlayerListSizeMax = v21,
		ContainerPadding = Size_100,
		ContainerPosition = UDim2.new(1, -Size_100, 0, Size_100),
		ExtraContainerPadding = v15.Size.Size_400,
		PlayerDropDownSizeX = if not FFlagEnableMobilePlayerListOnConsole then v14.PlayerDropDownSizeX * v23 else v16,
		PlayerDropDownOffset = v15.Size.Size_100,
		EntryBaseSizeX = if not v14.EntryBaseSizeX then nil else if not FFlagEnableMobilePlayerListOnConsole then v14.EntryBaseSizeX * v23 else v17,
		EntrySizeIncreasePerStat = v15.Size.Size_300,
		PlayerEntrySizeY = v15.Size.Size_1000,
		TeamEntrySizeY = v15.Size.Size_600,
		TeamNameTextSize = if not FFlagEnableMobilePlayerListOnConsole then nil else v15.FontSize.FontSize_300,
		StatEntrySizeX = v15.Size.Size_1600,
		TitleBarTextSize = if not FFlagEnableMobilePlayerListOnConsole then nil else v15.FontSize.FontSize_250,
		TitleBarSizeY = v15.Size.Size_500,
		PlayerIconSize = UDim2.new(0, v15.Size.Size_400, 0, v15.Size.Size_400),
		InitalPlayerEntryPadding = v15.Size.Size_300,
		PlayerEntryPadding = v15.Size.Size_300,
		PlayerEntryNamePadding = v15.Size.Size_100,
		StatTextPadding = v15.Size.Size_100,
		PlayerNameSize = UDim2.new(1, -v15.Size.Size_900, 1, 0),
		PlayerNameTextSize = v15.FontSize.FontSize_300,
		StatTextSize = v15.FontSize.FontSize_300,
		ScrollBarOffset = v15.Size.Size_100,
		ScrollBarSize = v15.Size.Size_200,
		PlayerDropDownSizeXMobile = if not FFlagEnableMobilePlayerListOnConsole then v14.PlayerDropDownSizeXMobile * v23 else v18,
		ScrollBarSizeMobile = v15.Size.Size_50,
		PlayerNameSizeXMobile = if not FFlagEnableMobilePlayerListOnConsole then v14.PlayerNameSizeXMobile * v23 else v19,
		PlayerIconSizeMobile = UDim2.fromOffset(v15.Size.Size_500, v15.Size.Size_500),
		PlayerNameTextSizeMobile = v15.FontSize.FontSize_350,
		StatTextSizeMobile = v15.FontSize.FontSize_350,
		PlayerNamePaddingXMobile = v15.Size.Size_350,
		TeamEntryTextPadding = v15.Size.Size_400,
		TeamEntryTextPaddingMobile = v15.Size.Size_350,
		PlayerIconBackgroundSize = UDim2.new(0, 66, 0, 66),
		DropDownButtonSizeY = v15.Size.Size_1400,
		DropDownButtonTextSize = if not FFlagEnableMobilePlayerListOnConsole then nil else v15.FontSize.FontSize_400,
		DropDownPadding = v15.Size.Size_250,
		DropDownRightOptionSize = v15.Size.Size_1400,
		DropDownIconSize = v15.Size.Size_900,
		DropDownHeaderSizeY = v15.Size.Size_2000,
		DropDownHeaderBackgroundSize = if not FFlagPlayerListDropDownShowPlatformName then v15.Size.Size_1600 else v15.Size.Size_1800,
		DropDownHeaderDisplayNameTextSize = if not FFlagEnableMobilePlayerListOnConsole then nil else v15.FontSize.FontSize_400,
		DropDownHeaderPlayerNameTextSize = if not FFlagEnableMobilePlayerListOnConsole then nil else v15.FontSize.FontSize_300,
		DropDownScreenSidePadding = Size_100
	}

	return Cryo.Dictionary.join(v14, t1)
end

return useLayoutValues
