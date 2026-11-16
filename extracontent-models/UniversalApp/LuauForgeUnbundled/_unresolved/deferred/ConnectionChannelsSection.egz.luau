local module = require("@luauforge/deferred/eeO")
local module2 = require("@luauforge/deferred/ega")

local images = require("@luauforge/deferred/egd").App.ImageSet.Images

local module3 = require("@luauforge/deferred/egt")
local module4 = require("@luauforge/deferred/efg")

local module5 = require("@luauforge/deferred/egA")
local module6 = require("@luauforge/deferred/egC")
local module7 = require("@luauforge/deferred/egG")
local module8 = require("@luauforge/deferred/egI")
local module9 = require("@luauforge/deferred/egM")
local module10 = require("@luauforge/deferred/egO")
local module11 = require("@luauforge/deferred/ehX")

local fFlagAddFriendsBannersNewUI_IXP = require("@luauforge/deferred/efc").FFlagAddFriendsBannersNewUI_IXP
local fFlagAFPConnectionsChannelsHeader = require("@luauforge/deferred/efc").FFlagAFPConnectionsChannelsHeader
local fFlagEnableSchoolEntry = require("@luauforge/deferred/efc").FFlagEnableSchoolEntry
local module12 = require("@luauforge/deferred/egH")

local useAppPolicy = require("@luauforge/deferred/egN").useAppPolicy

require("@luauforge/deferred/egL")

local v5 = {
	{ component = module8 },
	{ component = module9 }
}

if fFlagEnableSchoolEntry then
	table.insert(v5, { component = module10 })
end

local v6 = module12 and #v5 or nil

local function ConnectionChannelsSection(p2)
	local v7 = module4()
	local v8

	if not module12 then
		v8 = useAppPolicy(function(p3)
			return p3.getEnableProfileQrCode()
		end)
	end

	if fFlagAddFriendsBannersNewUI_IXP then
		local layoutOrder = p2.layoutOrder
		local navigateToLuaAppPages = p2.navigateToLuaAppPages
		local v9, v10

		if module12 then
			v9, v10 = module11(v6)
		else
			v9 = nil
		end

		local function fn(p3, p4, p5)
			return module.createElement(p3.component, {
				component = module7,
				componentUIProps = {
					layoutOrder = p4,
					itemSize = p5,
					onVisibilityChange = module12 and function(p6)
						v9(p4, p6)
					end or nil
				},
				fireAnalyticsEvent = v7,
				navigateToLuaAppPages = p2.navigateToLuaAppPages
			}), "Item"
		end

		local v13 = module.useCallback(fn, { v7, navigateToLuaAppPages, if module12 then v9 else nil })

		if module12 and v10 then
			return nil
		end

		local createElement = module.createElement
		local v15 = {
			layoutOrder = layoutOrder,
			items = v5,
			contextualInfoHeight = 25,
			renderItem = v13,
			headerComponent = 0
		}

		local v16 = if fFlagAFPConnectionsChannelsHeader and (module12 or v8) then module.createElement(module6) else nil
		v15.headerComponent = v16
		return createElement(module5, v15)
	else
		local layoutOrder = p2.layoutOrder or 1

		local v9 = module.useCallback(function(props)
			return module.createElement(module3, {
				maxWidth = 640,
				bannerIcon = images[props.icon],
				bannerTitle = props.title,
				bannerText = props.text,
				onActivated = props.onActivated,
				onBannerMounted = props.onMounted,
				layoutOrder = props.componentUIProps.layoutOrder
			})
		end, {})

		return module2.createFragment({
			ContactImporterBanner = module.createElement(module8, {
				component = v9,
				componentUIProps = { layoutOrder = layoutOrder },
				fireAnalyticsEvent = v7
			}),
			QRCodeBanner = module.createElement(module9, {
				component = v9,
				componentUIProps = {
					layoutOrder = layoutOrder + 1
				},
				fireAnalyticsEvent = v7,
				navigateToLuaAppPages = p2.navigateToLuaAppPages
			})
		})
	end
end

return ConnectionChannelsSection
