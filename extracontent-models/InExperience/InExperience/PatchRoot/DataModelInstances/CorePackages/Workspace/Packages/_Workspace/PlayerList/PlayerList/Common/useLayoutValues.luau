local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SignalsReact = require(parent2.SignalsReact)
local Display = require(parent2.Display)
local Cryo = require(parent2.Cryo)

local Foundation = require(parent2.Foundation)
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local LayoutValuesContext = require(script.Parent.LayoutValuesContext)

local FFlagEnableMobilePlayerListOnConsole = require(parent.Flags.FFlagEnableMobilePlayerListOnConsole)
local FFlagPlayerListDropDownShowPlatformName = require(parent.Flags.FFlagPlayerListDropDownShowPlatformName)

local function useLayoutValues()
	local v = React.useContext(LayoutValuesContext)

	local v2 = useTokens()
	local playerDropDownSizeX

	if FFlagEnableMobilePlayerListOnConsole then
		playerDropDownSizeX = useScaledValue(v.PlayerDropDownSizeX * 10) / 10
	end

	local entryBaseSizeX

	if FFlagEnableMobilePlayerListOnConsole then
		entryBaseSizeX = useScaledValue((v.EntryBaseSizeX or 150) * 10) / 10
	end

	local playerDropDownSizeXMobile

	if FFlagEnableMobilePlayerListOnConsole then
		playerDropDownSizeXMobile = useScaledValue(v.PlayerDropDownSizeXMobile * 10) / 10
	end

	local playerNameSizeXMobile

	if FFlagEnableMobilePlayerListOnConsole then
		playerNameSizeXMobile = useScaledValue(v.PlayerNameSizeXMobile * 10) / 10
	end

	local playerListSizeMin

	if FFlagEnableMobilePlayerListOnConsole then
		playerListSizeMin = useScaledValue(500)
	end

	local playerListSizeMax

	if FFlagEnableMobilePlayerListOnConsole then
		playerListSizeMax = useScaledValue(600)
	end

	local v3

	if not FFlagEnableMobilePlayerListOnConsole then
		v3 = SignalsReact.useSignalState(Display.GetDisplayStore)
	end

	local v4

	if not FFlagEnableMobilePlayerListOnConsole then
		v4 = SignalsReact.useSignalState(v3.getUIScale)
	end

	local size_100 = v2.Size.Size_100

	local v5 = {}
	v5.PlayerListSizeMin = playerListSizeMin
	v5.PlayerListSizeMax = playerListSizeMax
	v5.ContainerPadding = size_100
	v5.ContainerPosition = UDim2.new(1, -size_100, 0, size_100)
	v5.ExtraContainerPadding = v2.Size.Size_400

	if not FFlagEnableMobilePlayerListOnConsole then
		playerDropDownSizeX = v.PlayerDropDownSizeX * v4
	end

	v5.PlayerDropDownSizeX = playerDropDownSizeX

	v5.PlayerDropDownOffset = v2.Size.Size_100

	if v.EntryBaseSizeX then
		if not FFlagEnableMobilePlayerListOnConsole then
			entryBaseSizeX = v.EntryBaseSizeX * v4
		end
	else
		entryBaseSizeX = nil
	end

	v5.EntryBaseSizeX = entryBaseSizeX

	v5.EntrySizeIncreasePerStat = v2.Size.Size_300
	v5.PlayerEntrySizeY = v2.Size.Size_1000
	v5.TeamEntrySizeY = v2.Size.Size_600
	local teamNameTextSize

	if FFlagEnableMobilePlayerListOnConsole then
		teamNameTextSize = v2.FontSize.FontSize_300
	end

	v5.TeamNameTextSize = teamNameTextSize

	v5.StatEntrySizeX = v2.Size.Size_1600
	local titleBarTextSize

	if FFlagEnableMobilePlayerListOnConsole then
		titleBarTextSize = v2.FontSize.FontSize_250
	end

	v5.TitleBarTextSize = titleBarTextSize

	v5.TitleBarSizeY = v2.Size.Size_500

	v5.PlayerIconSize = UDim2.new(0, v2.Size.Size_400, 0, v2.Size.Size_400)
	v5.InitalPlayerEntryPadding = v2.Size.Size_300
	v5.PlayerEntryPadding = v2.Size.Size_300
	v5.PlayerEntryNamePadding = v2.Size.Size_100
	v5.StatTextPadding = v2.Size.Size_100

	v5.PlayerNameSize = UDim2.new(1, -v2.Size.Size_900, 1, 0)
	v5.PlayerNameTextSize = v2.FontSize.FontSize_300
	v5.StatTextSize = v2.FontSize.FontSize_300

	v5.ScrollBarOffset = v2.Size.Size_100
	v5.ScrollBarSize = v2.Size.Size_200

	if not FFlagEnableMobilePlayerListOnConsole then
		playerDropDownSizeXMobile = v.PlayerDropDownSizeXMobile * v4
	end

	v5.PlayerDropDownSizeXMobile = playerDropDownSizeXMobile

	v5.ScrollBarSizeMobile = v2.Size.Size_50

	if not FFlagEnableMobilePlayerListOnConsole then
		playerNameSizeXMobile = v.PlayerNameSizeXMobile * v4
	end

	v5.PlayerNameSizeXMobile = playerNameSizeXMobile

	v5.PlayerIconSizeMobile = UDim2.fromOffset(v2.Size.Size_500, v2.Size.Size_500)
	v5.PlayerNameTextSizeMobile = v2.FontSize.FontSize_350
	v5.StatTextSizeMobile = v2.FontSize.FontSize_350
	v5.PlayerNamePaddingXMobile = v2.Size.Size_350
	v5.TeamEntryTextPadding = v2.Size.Size_400
	v5.TeamEntryTextPaddingMobile = v2.Size.Size_350

	v5.PlayerIconBackgroundSize = UDim2.new(0, 66, 0, 66)

	v5.DropDownButtonSizeY = v2.Size.Size_1400
	local dropDownButtonTextSize

	if FFlagEnableMobilePlayerListOnConsole then
		dropDownButtonTextSize = v2.FontSize.FontSize_400
	end

	v5.DropDownButtonTextSize = dropDownButtonTextSize

	v5.DropDownPadding = v2.Size.Size_250
	v5.DropDownRightOptionSize = v2.Size.Size_1400
	v5.DropDownIconSize = v2.Size.Size_900
	v5.DropDownHeaderSizeY = v2.Size.Size_2000
	local dropDownHeaderBackgroundSize

	if FFlagPlayerListDropDownShowPlatformName then
		dropDownHeaderBackgroundSize = v2.Size.Size_1800
	else
		dropDownHeaderBackgroundSize = v2.Size.Size_1600
	end

	v5.DropDownHeaderBackgroundSize = dropDownHeaderBackgroundSize
	local dropDownHeaderDisplayNameTextSize

	if FFlagEnableMobilePlayerListOnConsole then
		dropDownHeaderDisplayNameTextSize = v2.FontSize.FontSize_400
	end

	v5.DropDownHeaderDisplayNameTextSize = dropDownHeaderDisplayNameTextSize
	local dropDownHeaderPlayerNameTextSize

	if FFlagEnableMobilePlayerListOnConsole then
		dropDownHeaderPlayerNameTextSize = v2.FontSize.FontSize_300
	end

	v5.DropDownHeaderPlayerNameTextSize = dropDownHeaderPlayerNameTextSize

	v5.DropDownScreenSidePadding = size_100

	v5.PlayerScrollListSizeTwoTabsOnLegacy = UDim2.new(1, 0, 1, -v2.Size.Size_1100)

	return Cryo.Dictionary.join(v, v5)
end

return useLayoutValues
