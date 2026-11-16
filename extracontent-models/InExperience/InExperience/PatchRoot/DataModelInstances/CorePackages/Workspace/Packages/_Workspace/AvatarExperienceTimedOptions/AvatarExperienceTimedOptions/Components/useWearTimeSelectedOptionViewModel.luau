local LocalizationService = game:GetService("LocalizationService")
local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

require(parent.AvatarExperienceCommon)

local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS

local function getPermanentPrice(items)
	for _, item in items do
		if item.days == 0 then
			return item.price
		end
	end

	return 0
end

local function useWearTimeSelectedOptionViewModel(data)
	local tokens = useTokens()

	local localization2 = React.useMemo(function()
		return localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	local state, setState = React.useState(nil)

	local useEffect = React.useEffect
	local function fn()
		if FFlagAXDurablesForMIS and data.selectedTimedOptionIndexInReducer ~= nil then
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
	local v

	if FFlagAXDurablesForMIS then
		v = data.selectedTimedOptionIndexInReducer
	end

	useEffect(fn, { options, v })
	local selectedOption

	if state then
		selectedOption = data.options[state]
	end

	local v2 = not selectedOption and 0 or selectedOption.days
	local localizedText = useLocalization({
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite",
		xDay = {
			"Feature.Durables.BottomBar.RentalDuration",
			num = v2
		},
		xDays = {
			"Feature.Durables.BottomBar.RentalDurationPlural",
			num = v2
		},
		xDayList = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDay",
			num = v2
		},
		xDaysList = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
			num = v2
		}
	})

	local state2, setState2 = React.useState(false)
	local ref = React.useRef(nil)
	local price

	if selectedOption then
		price = selectedOption.price
	else
		local flag = true

		for _, option in data.options do
			if option.days == 0 then
				price = option.price
				flag = false
				break
			end
		end

		if flag then
			price = 0
		end
	end

	local subLabelText, listLabelText

	if v2 == 0 then
		subLabelText = localizedText.infinite
		listLabelText = localizedText.infinite
	elseif v2 == 1 then
		subLabelText = localizedText.xDay
		listLabelText = localizedText.xDayList
	else
		subLabelText = localizedText.xDays
		listLabelText = localizedText.xDaysList
	end

	return {
		tokens = tokens,
		localization = localization2,
		selectedIndex = state,
		setSelectedIndex = setState,
		selectedOption = selectedOption,
		days = v2,
		localizedText = localizedText,
		isOpen = state2,
		setIsOpen = setState2,
		anchorRef = ref,
		price = price,
		subLabelText = subLabelText,
		listLabelText = listLabelText,
		handleOptionActivated = React.useCallback(function(p: number)
			setState(p)

			if data.onOptionActivated then
				data.onOptionActivated(p)
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
