local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AvatarExperienceTimedOptions = require(CorePackages.Workspace.Packages.AvatarExperienceTimedOptions)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local ActionButton = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ActionButton)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local withStyle = UIBlox.Style.withStyle
local WearTimeSelectedOption = AvatarExperienceTimedOptions.WearTimeSelectedOption
local SetSelectedTimedOption = AvatarExperienceCatalog.State.Actions.SetSelectedTimedOption

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Catalog.Components.ActionBar.BuyActionBar.useBuyActionBarButtonProps)

local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Display = require(CorePackages.Workspace.Packages.Display)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local v20 = game:DefineFastFlag("AXTimedOptionsBarHeightFix", false) and not FFlagAXDurablesForMIS

function ActionBarWithTimedOptions(t1: {[any]: any}) -- line: 45
	-- upvalues: useTokens (copy), FFlagAXDurablesForMIS (copy), useDispatch (copy), React (copy), SetSelectedTimedOption (copy), FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy), withStyle (copy), View (copy), v20 (copy), WearTimeSelectedOption (copy), ActionButton (copy)
	local v22 = useTokens()
	local v23 = if not FFlagAXDurablesForMIS then nil else useDispatch()

	React.useEffect(function() -- line: 51
		-- upvalues: t1 (copy), FFlagAXDurablesForMIS (copy)
		if t1.timedOptions then
			if FFlagAXDurablesForMIS then
				if t1.selectedTimedOptionIndexInReducer == nil then
					for _, v27 in t1.timedOptions do
						if v27.selected then
							if not t1.onSelectedDaysChanged then
								return
							end

							t1.onSelectedDaysChanged(v27.days)

							return
						end
					end

					return
				end

				local v28 = t1.timedOptions[t1.selectedTimedOptionIndexInReducer]

				if v28 and t1.onSelectedDaysChanged then
					t1.onSelectedDaysChanged(v28.days)

					return
				end
			else
				for _, v30 in t1.timedOptions do
					if v30.selected then
						if not t1.onSelectedDaysChanged then
							return
						end

						t1.onSelectedDaysChanged(v30.days)

						return
					end
				end
			end
		end
	end, {
		t1.timedOptions,
		t1.onSelectedDaysChanged,
		if not FFlagAXDurablesForMIS then nil else t1.selectedTimedOptionIndexInReducer
	})

	local v24 = React.useCallback(function(n1: number) -- line: 90
		-- upvalues: t1 (copy), FFlagAXDurablesForMIS (copy), v23 (copy), SetSelectedTimedOption (copy)
		if t1.onSelectedDaysChanged then
			local v32 = if not t1.timedOptions[n1] then nil else t1.timedOptions[n1].days

			if v32 == 0 then
				t1.onSelectedDaysChanged(nil)
			else
				t1.onSelectedDaysChanged(v32)
			end

			if FFlagAXDurablesForMIS and v23 and t1.itemId and t1.itemType then
				v23(SetSelectedTimedOption({
					itemId = t1.itemId,
					itemType = t1.itemType,
					selectedTimedOptionIndex = n1
				}))
			end
		end
	end, {
		t1.onSelectedDaysChanged,
		t1.timedOptions,
		if not FFlagAXDurablesForMIS then nil else t1.itemId,
		if not FFlagAXDurablesForMIS then nil else t1.itemType,
		if not FFlagAXDurablesForMIS then nil else v23
	})
	local v25 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return withStyle(function(p1) -- line: 123
		-- upvalues: React (copy), View (copy), v20 (copy), v22 (copy), FFlagAXDurablesForMIS (copy), FFlagEnableLeftNavOnConsole (copy), v25 (copy), WearTimeSelectedOption (copy), t1 (copy), v24 (copy), ActionButton (copy)
		return React.createElement(View, {
			tag = "size-full-0",
			Size = if not v20 then UDim2.new(1, 0, 0, v22.Size.Size_1500) else UDim2.new(1, 0, 0, v22.Size.Size_1800)
		}, {
			ActionBarFrame = React.createElement(View, {
				tag = not FFlagAXDurablesForMIS and "padding-left-large padding-right-large padding-top-small bg-surface-0" or "padding-x-xlarge padding-top-large bg-surface-0",
				Size = if not FFlagAXDurablesForMIS and not v20 then UDim2.new(1, not FFlagEnableLeftNavOnConsole and 0 or v25.right, 0, v22.Size.Size_1500 + (FFlagEnableLeftNavOnConsole and v25.bottom or 0)) else UDim2.new(1, not FFlagEnableLeftNavOnConsole and 0 or v25.right, 0, v22.Size.Size_1800 + (FFlagEnableLeftNavOnConsole and v25.bottom or 0)),
				Position = if not FFlagAXDurablesForMIS and not v20 then UDim2.new(0, 0, 1, -v22.Size.Size_1500) else UDim2.new(0, 0, 1, -v22.Size.Size_1800),
				padding = if not FFlagEnableLeftNavOnConsole then nil else {
					right = UDim.new(0, v25.right),
					bottom = UDim.new(0, v25.bottom)
				}
			}, {
				TimedOptions = React.createElement(View, {
					tag = "bg-surface-0",
					LayoutOrder = 1,
					Size = UDim2.new(0, v22.Size.Size_2000, 0, v22.Size.Size_1000),
					Position = if not FFlagAXDurablesForMIS then if not v20 then nil else UDim2.fromOffset(0, v22.Size.Size_200) else UDim2.new(0, 0, 0, -v22.Size.Size_200)
				}, {
					OptionMenu = React.createElement(WearTimeSelectedOption, {
						options = t1.timedOptions,
						selectedTimedOptionIndexInReducer = if not FFlagAXDurablesForMIS then nil else t1.selectedTimedOptionIndexInReducer,
						onOptionActivated = v24
					})
				}),
				ActionButton = React.createElement(ActionButton, {
					LayoutOrder = 3,
					Size = if not FFlagAXDurablesForMIS then UDim2.new(0.5, -v22.Size.Size_250, 1, -v22.Size.Size_250) else UDim2.new(0.5, -v22.Size.Size_250, 0, v22.Size.Size_1000),
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0),
					Font = p1.Font,
					buttonProps = t1.buttonProps
				})
			})
		})
	end)
end

return ActionBarWithTimedOptions
