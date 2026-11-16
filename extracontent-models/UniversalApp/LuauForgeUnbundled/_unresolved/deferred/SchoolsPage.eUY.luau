local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/eUZ")

local useIsWideMode = require("@luauforge/deferred/eVa").Hooks.useIsWideMode

local module4 = require("@luauforge/deferred/eVb")
local module5 = require("@luauforge/deferred/eha")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function SchoolsPage(props)
	local v5 = useIsWideMode()
	local v6 = module3.useDeviceInsets()
	local v7 = useTokens()
	local maxContentWidth = props.maxContentWidth or module5.PAGE_MAX_CONTENT_WIDTH
	local v8

	if v5 then
		v8 = { top = UDim.new(0, v7.Size.Size_600) }
	else
		v8 = { top = 0, bottom = 0 }
		local v9 = if v6.top > 0 then UDim.new(0, v6.top) else nil
		v8.top = v9
		local v10 = if v6.bottom > 0 then UDim.new(0, v6.bottom) else nil
		v8.bottom = v10
	end

	local v9

	if typeof(props.children) == "table" then
		v9 = table.clone(props.children)
	else
		v9 = { Content = props.children }
	end

	v9.WidthConstraint = module.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(maxContentWidth, 1e999)
	})

	return module.createElement(view, {
		tag = {
			["col size-full bg-surface-0"] = true,
			["align-x-center gap-xxlarge"] = v5
		},
		padding = v8,
		testId = props.testId
	}, {
		Header = module.createElement(module4, {
			layoutOrder = 1,
			title = props.title,
			onBack = props.onBack,
			renderTrailing = props.renderTrailing
		}),
		ContentArea = module.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "col align-x-center fill size-full-0 padding-x-xlarge"
			},
			{
				Column = module.createElement(view, {
					tag = {
						["col gap-large size-full-0 padding-top-medium"] = true,
						fill = props.fillContent == true,
						["auto-y"] = props.fillContent ~= true
					}
				}, v9)
			}
		)
	})
end

return SchoolsPage
