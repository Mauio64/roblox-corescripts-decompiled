local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local Foundation = require(SchoolsParent.Foundation)
local Responsive = require(SchoolsParent.Responsive)
local useIsWideMode = require(SchoolsParent.SocialCommon).Hooks.useIsWideMode
local SchoolsPageHeader = require(Schools.Components.Common.SchoolsPageHeader)
local Constants = require(Schools.Common.Constants)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function SchoolsPage(t1: {[any]: any}) -- line: 30
	-- upvalues: useIsWideMode (copy), Responsive (copy), useTokens (copy), Constants (copy), React (copy), View (copy), SchoolsPageHeader (copy)
	local v13 = useIsWideMode()
	local v14 = Responsive.useDeviceInsets()
	local v15 = useTokens()
	local v16 = t1.maxContentWidth or Constants.PAGE_MAX_CONTENT_WIDTH
	local v17 = if not v13 then {
		top = if not (v14.top > 0) then nil else UDim.new(0, v14.top),
		bottom = if not (v14.bottom > 0) then nil else UDim.new(0, v14.bottom)
	} else {
		top = UDim.new(0, v15.Size.Size_600)
	}
	local v18 = if typeof(t1.children) ~= "table" then {
		Content = t1.children
	} else table.clone(t1.children)

	v18.WidthConstraint = React.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(v16, 1e999)
	})

	return React.createElement(View, {
		tag = {
			["col size-full bg-surface-0"] = true,
			["align-x-center gap-xxlarge"] = v13
		},
		padding = v17,
		testId = t1.testId
	}, {
		Header = React.createElement(SchoolsPageHeader, {
			layoutOrder = 1,
			title = t1.title,
			onBack = t1.onBack,
			renderTrailing = t1.renderTrailing
		}),
		ContentArea = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-center fill size-full-0 padding-x-xlarge"
		}, {
			Column = React.createElement(View, {
				tag = {
					["col gap-large size-full-0 padding-top-medium"] = true,
					fill = t1.fillContent == true,
					["auto-y"] = t1.fillContent ~= true
				}
			}, v18)
		})
	})
end

return SchoolsPage
