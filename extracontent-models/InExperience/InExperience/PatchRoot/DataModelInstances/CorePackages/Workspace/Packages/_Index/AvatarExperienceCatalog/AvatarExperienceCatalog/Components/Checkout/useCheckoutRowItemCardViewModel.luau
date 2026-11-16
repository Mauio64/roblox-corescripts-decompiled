local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
require(AvatarExperienceCatalog.Stores.createAXShoppingCartStore)
local useTimedOptionsFtux = require(AvatarExperienceCatalog.Hooks.useTimedOptionsFtux)

local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local defineFastInt = game:DefineFastInt("2OptionOfferPillTooltipTimeout", 5)

local function useCheckoutRowItemCardViewModel(p)
	local state, setState = React.useState(function()
		if p.timedOptions then
			for _, timedOption in p.timedOptions do
				if timedOption.selected then
					return timedOption.price
				end
			end
		end

		return nil
	end)

	local useEffect = React.useEffect
	local function fn()
		if p.selectedTimedOptionIndexInReducer == nil then
			if FFlagAXMISWithBlackbird and p.timedOptions then
				for _, timedOption in p.timedOptions do
					if timedOption.selected then
						setState(timedOption.price)
						return
					end
				end
			end
		else
			local v = p.timedOptions and p.timedOptions[p.selectedTimedOptionIndexInReducer]

			if v then
				setState(v.price)
			end
		end
	end
	local selectedTimedOptionIndexInReducer = p.selectedTimedOptionIndexInReducer
	local v

	if FFlagAXMISWithBlackbird then
		v = p.timedOptions
	end

	useEffect(fn, { selectedTimedOptionIndexInReducer, v })

	local state2 = nil
	local setState2 = nil

	if FFlagAXDurables2Option then
		local v2 = useTimedOptionsFtux()

		state2, setState2 = React.useState(v2.shouldShow2OptionOfferPillTooltip())

		React.useEffect(function()
			local thread

			if state2 then
				thread = task.delay(defineFastInt, function()
					setState2(false)
					v2.hide2OptionOfferPillTooltip()
				end)
			else
				thread = nil
			end

			return function()
				if thread then
					task.cancel(thread)
				end
			end
		end, { state2, setState2, v2 })
	end

	local v2 = {
		selectedTimedOptionPrice = state,
		setSelectedTimedOptionPrice = setState,
		showOfferPillTooltip = nil
	}
	local showOfferPillTooltip

	if FFlagAXDurables2Option then
		showOfferPillTooltip = state2
	end

	v2.showOfferPillTooltip = showOfferPillTooltip
	return v2
end

return useCheckoutRowItemCardViewModel
