local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createAXShoppingCartStore")
local useTimedOptionsFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useTimedOptionsFtux")

local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local fFlagAXDurables2Option = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXDurables2Option
local defineFastInt = game:DefineFastInt("2OptionOfferPillTooltipTimeout", 5)

local function useCheckoutRowItemCardViewModel(p2)
	local state, setState = React.useState(function()
		if p2.timedOptions then
			for k, timedOption in p2.timedOptions do
				if timedOption.selected then
					return timedOption.price
				end
			end
		end

		return nil
	end)

	local useEffect = React.useEffect
	local function fn()
		if p2.selectedTimedOptionIndexInReducer == nil then
			if fFlagAXMISWithBlackbird and p2.timedOptions then
				for k, timedOption in p2.timedOptions do
					if timedOption.selected then
						setState(timedOption.price)
						return
					end
				end
			end
		else
			local v5 = p2.timedOptions and p2.timedOptions[p2.selectedTimedOptionIndexInReducer]

			if v5 then
				setState(v5.price)
			end
		end
	end
	local selectedTimedOptionIndexInReducer = p2.selectedTimedOptionIndexInReducer
	local v6 = if fFlagAXMISWithBlackbird then p2.timedOptions else nil
	useEffect(fn, { selectedTimedOptionIndexInReducer, v6 })

	local state2 = nil
	local setState2 = nil

	if fFlagAXDurables2Option then
		local v7 = useTimedOptionsFtux()

		state2, setState2 = React.useState(v7.shouldShow2OptionOfferPillTooltip())

		React.useEffect(function()
			local thread

			if state2 then
				thread = task.delay(defineFastInt, function()
					setState2(false)
					v7.hide2OptionOfferPillTooltip()
				end)
			else
				thread = nil
			end

			return function()
				if thread then
					task.cancel(thread)
				end
			end
		end, { state2, setState2, v7 })
	end

	return {
		selectedTimedOptionPrice = state,
		setSelectedTimedOptionPrice = setState,
		showOfferPillTooltip = if fFlagAXDurables2Option then state2 else nil
	}
end

return useCheckoutRowItemCardViewModel
