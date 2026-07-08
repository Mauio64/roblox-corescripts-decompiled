local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Divider = Foundation.Divider
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local RadioGroup = Foundation.RadioGroup
local FoundationText = Foundation.Text
local View = Foundation.View
local withDefaults = Foundation.Utility.withDefaults
local useList = require(script.Parent.Parent.useList)
local FFlagAbuseReportMenuV2 = require(Parent.SharedFlags).FFlagAbuseReportMenuV2
local v14 = game:DefineFastFlag("ReportListRadioSelectable", false)
local t1 = {
	hasDivider = false
}

local function ListItem(t2: {[any]: any}, p1) -- line: 35
	-- upvalues: withDefaults (copy), t1 (copy), useList (copy), React (copy), View (copy), FoundationText (copy), RadioGroup (copy), v14 (copy), InputSize (copy), FFlagAbuseReportMenuV2 (copy), Icon (copy), IconName (copy), Divider (copy)
	local v19 = withDefaults(t2, t1)
	local v20 = useList()
	local value = v20.value
	local v22 = React.useRef(nil)
	local v23 = React.useCallback(function() -- line: 41
		-- upvalues: v20 (copy), v19 (copy)
		v20.onValueChanged(v19.value)
	end, {
		v20,
		v19.value
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y col",
		ref = p1
	}, {
		ListItem = React.createElement(View, {
			tag = "size-full-0 auto-y padding-medium",
			onActivated = v23
		}, {
			ListItemContent = React.createElement(View, {
				tag = {
					["size-full-0 auto-y row gap-medium align-x-center align-y-center flex-between"] = true,
					["padding-x-large"] = v19.hasMargin
				}
			}, {
				TextBlock = React.createElement(View, {
					tag = "size-full-0 auto-xy col gap-small shrink",
					LayoutOrder = 0
				}, {
					TitleBlock = React.createElement(View, {
						tag = "auto-xy col gap-xsmall",
						LayoutOrder = 0
					}, {
						Title = React.createElement(FoundationText, {
							RichText = true,
							tag = "auto-xy text-align-x-left text-title-medium text-wrap content-emphasis",
							LayoutOrder = 0,
							Text = v19.title
						}),
						Metadata = v19.metadata and React.createElement(FoundationText, {
							RichText = true,
							tag = "auto-xy text-align-x-left text-body-small text-wrap",
							LayoutOrder = 1,
							Text = v19.metadata
						})
					}),
					Description = v19.description and React.createElement(FoundationText, {
						RichText = true,
						tag = "auto-xy text-align-x-left text-body-small text-wrap",
						LayoutOrder = 1,
						Text = v19.description
					})
				}),
				AccessoryBlock = React.createElement(View, {
					tag = "size-600-0 auto-y align-y-center col",
					LayoutOrder = 1
				}, {
					Radio = v19.trailingAccessory == "Radio" and React.createElement(RadioGroup.Root, {
						onValueChanged = v23,
						value = value,
						Selectable = not v14
					}, { React.createElement(RadioGroup.Item, {
						label = "",
						value = v19.value,
						size = InputSize.Small,
						ref = v22
					}) }),
					Chevron = if not FFlagAbuseReportMenuV2 then nil else v19.trailingAccessory == "Chevron" and React.createElement(Icon, {
						name = IconName.ChevronLargeRight
					})
				})
			})
		}),
		Divider = v19.hasDivider and React.createElement(Divider, {
			LayoutOrder = 2
		}) or nil
	})
end

return React.memo(React.forwardRef(ListItem))
