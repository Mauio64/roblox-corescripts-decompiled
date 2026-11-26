local LocalizationService = game:GetService("LocalizationService")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceFlags")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Localization")
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/RobloxAppLocales").Localization
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceCommon")

local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS

local function getPermanentPrice(items)
	for k, item in items do
		if item.days == 0 then
			return item.price
		end
	end

	return 0
end

local function useWearTimeSelectedOptionViewModel(data)
	local v5 = useTokens()

	local v6 = React.useMemo(function()
		return localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	local state, setState = React.useState(nil)

	local useEffect = React.useEffect
	local function fn()
		if fFlagAXDurablesForMIS and data.selectedTimedOptionIndexInReducer ~= nil then
			setState(data.selectedTimedOptionIndexInReducer)
			return
		end

		for k, option in data.options do
			if option.selected then
				setState(k)
				break
			end
		end
	end
	local options = data.options
	local v8 = if fFlagAXDurablesForMIS then data.selectedTimedOptionIndexInReducer else nil
	useEffect(fn, { options, v8 })

	local v9 = if state then data.options[state] else nil

	local v10 = not v9 and 0 or v9.days
	local v11 = useLocalization({
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite",
		xDay = {
			"Feature.Durables.BottomBar.RentalDuration",
			num = v10
		},
		xDays = {
			"Feature.Durables.BottomBar.RentalDurationPlural",
			num = v10
		},
		xDayList = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDay",
			num = v10
		},
		xDaysList = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
			num = v10
		}
	})

	local state2, setState2 = React.useState(false)
	local ref = React.useRef(nil)
	local v12

	if v9 then
		v12 = v9.price
	else
		local flag = true

		for k, option in data.options do
			if option.days == 0 then
				v12 = option.price
				flag = false
				break
			end
		end

		if flag then
			v12 = 0
		end
	end

	local v13, v14

	if v10 == 0 then
		v13 = v11.infinite
		v14 = v11.infinite
	elseif v10 == 1 then
		v13 = v11.xDay
		v14 = v11.xDayList
	else
		v13 = v11.xDays
		v14 = v11.xDaysList
	end

	return {
		tokens = v5,
		localization = v6,
		selectedIndex = state,
		setSelectedIndex = setState,
		selectedOption = v9,
		days = v10,
		localizedText = v11,
		isOpen = state2,
		setIsOpen = setState2,
		anchorRef = ref,
		price = v12,
		subLabelText = v13,
		listLabelText = v14,
		handleOptionActivated = React.useCallback(function(p2)
			setState(p2)

			if data.onOptionActivated then
				data.onOptionActivated(p2)
			end

			setState2(false)
		end, { data.onOptionActivated }),
		updatedOptions = React.useMemo(function()
			local result = {}

			for k, option in data.options do
				result[k] = {
					days = option.days,
					price = option.price,
					selected = k == state,
					discountInformation = option.discountInformation
				}
			end

			return result
		end, { data.options, state }),
		disableOptionSelection = data.disableOptionSelection
	}
end

return useWearTimeSelectedOptionViewModel
