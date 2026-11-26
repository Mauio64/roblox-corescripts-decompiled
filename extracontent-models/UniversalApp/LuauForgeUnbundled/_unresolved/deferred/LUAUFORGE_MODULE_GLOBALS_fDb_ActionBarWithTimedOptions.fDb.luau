local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/deferred/fDc")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module4 = require("@luauforge/deferred/fDd")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local withStyle = UIBlox.Style.withStyle
local wearTimeSelectedOption = module.WearTimeSelectedOption
local setSelectedTimedOption = AvatarExperienceCatalog.State.Actions.SetSelectedTimedOption
require("@luauforge/bundled/dPs")

require("@luauforge/deferred/fDe")

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module5 = require("@luauforge/bundled/dXA")

local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local v5 = game:DefineFastFlag("AXTimedOptionsBarHeightFix", false) and not fFlagAXDurablesForMIS

function LUAUFORGE_MODULE_GLOBALS_fDb_ActionBarWithTimedOptions(data)
	local v6 = useTokens()
	local v7 = if fFlagAXDurablesForMIS then useDispatch() else nil

	local useEffect = React.useEffect
	local function fn()
		if not data.timedOptions then
			return
		end

		if fFlagAXDurablesForMIS then
			if data.selectedTimedOptionIndexInReducer == nil then
				for k, timedOption in data.timedOptions do
					if timedOption.selected then
						if not data.onSelectedDaysChanged then
							return
						end

						data.onSelectedDaysChanged(timedOption.days)

						return
					end
				end
			else
				local timedOption = data.timedOptions[data.selectedTimedOptionIndexInReducer]

				if timedOption and data.onSelectedDaysChanged then
					data.onSelectedDaysChanged(timedOption.days)
				end
			end
		else
			for k, timedOption in data.timedOptions do
				if timedOption.selected then
					if not data.onSelectedDaysChanged then
						break
					end

					data.onSelectedDaysChanged(timedOption.days)

					return
				end
			end
		end
	end

	local timedOptions = data.timedOptions
	local onSelectedDaysChanged = data.onSelectedDaysChanged
	local v9 = if fFlagAXDurablesForMIS then data.selectedTimedOptionIndexInReducer else nil
	useEffect(fn, { timedOptions, onSelectedDaysChanged, v9 })

	local useCallback = React.useCallback
	local function fn2(p2)
		if data.onSelectedDaysChanged then
			local days = if data.timedOptions[p2] then data.timedOptions[p2].days else nil

			if days == 0 then
				data.onSelectedDaysChanged(nil)
			else
				data.onSelectedDaysChanged(days)
			end

			if fFlagAXDurablesForMIS and v7 and data.itemId and data.itemType then
				v7(setSelectedTimedOption({
					itemId = data.itemId,
					itemType = data.itemType,
					selectedTimedOptionIndex = p2
				}))
			end
		end
	end

	local onSelectedDaysChanged2 = data.onSelectedDaysChanged
	local timedOptions2 = data.timedOptions
	local itemId = if fFlagAXDurablesForMIS then data.itemId else nil
	local itemType = if fFlagAXDurablesForMIS then data.itemType else nil
	local v12 = useCallback(fn2, {
		onSelectedDaysChanged2,
		timedOptions2,
		itemId,
		itemType,
		if fFlagAXDurablesForMIS then v7 else nil
	})

	local v13 = useSignalState(module5.GetDisplayStore().getDeviceSafePadding)

	return withStyle(function(p2)
		local createElement = React.createElement

		local v16 = if v5 then UDim2.new(1, 0, 0, v6.Size.Size_1800) else UDim2.new(1, 0, 0, v6.Size.Size_1500)

		local createElement2 = React.createElement
		local v19 = {
			tag = fFlagAXDurablesForMIS and "padding-x-xlarge padding-top-large bg-surface-0" or "padding-left-large padding-right-large padding-top-small bg-surface-0",
			Size = 0,
			Position = 0,
			padding = 0
		}

		local v20 = if fFlagAXDurablesForMIS or v5 then UDim2.new(1, v13.right, 0, v6.Size.Size_1800 + v13.bottom) else UDim2.new(1, v13.right, 0, v6.Size.Size_1500 + v13.bottom)
		v19.Size = v20

		local v21 = if fFlagAXDurablesForMIS or v5 then UDim2.new(0, 0, 1, -v6.Size.Size_1800) else UDim2.new(0, 0, 1, -v6.Size.Size_1500)
		v19.Position = v21

		v19.padding = {
			right = UDim.new(0, v13.right),
			bottom = UDim.new(0, v13.bottom)
		}

		local createElement3 = React.createElement
		local v23 = {
			tag = "bg-surface-0",
			LayoutOrder = 1,
			Size = UDim2.new(0, v6.Size.Size_2000, 0, v6.Size.Size_1000),
			Position = 0
		}
		local udim

		if fFlagAXDurablesForMIS then
			udim = UDim2.new(0, 0, 0, -v6.Size.Size_200)
		elseif v5 then
			udim = UDim2.fromOffset(0, v6.Size.Size_200)
		end

		v23.Position = udim

		local createElement4 = React.createElement
		local v26 = {
			options = data.timedOptions,
			selectedTimedOptionIndexInReducer = 0,
			onOptionActivated = 0
		}

		local v27 = if fFlagAXDurablesForMIS then data.selectedTimedOptionIndexInReducer else nil
		v26.selectedTimedOptionIndexInReducer = v27

		v26.onOptionActivated = v12
		local children = {
			TimedOptions = createElement3(view, v23, {
				OptionMenu = createElement4(wearTimeSelectedOption, v26)
			}),
			ActionButton = 0
		}

		local createElement5 = React.createElement

		local v30 = if fFlagAXDurablesForMIS then UDim2.new(0.5, -v6.Size.Size_250, 0, v6.Size.Size_1000) else UDim2.new(0.5, -v6.Size.Size_250, 1, -v6.Size.Size_250)
		children.ActionButton = createElement5(module4, {
			Size = v30,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 3,
			Font = p2.Font,
			buttonProps = data.buttonProps
		})
		return createElement(view, { tag = "size-full-0", Size = v16 }, {
			ActionBarFrame = createElement2(view, v19, children)
		})
	end)
end

return LUAUFORGE_MODULE_GLOBALS_fDb_ActionBarWithTimedOptions
