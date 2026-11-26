require("@luauforge/deferred/gzP")

local module = require("@luauforge/deferred/gAb")

require("@luauforge/deferred/gzW")

local module2 = require("@luauforge/deferred/gzS")

local module3 = require("@luauforge/deferred/gzT")
local text = module3.Text
local view = module3.View

local localization = require("@luauforge/deferred/gAc").Localization
local LocalizationService = game:GetService("LocalizationService")
local v5 = localization.new(LocalizationService.RobloxLocaleId)

local function createPolicyEducationConfig(data)
	local function PolicyEducationConfig(p2)
		local v6 = if data.description and data.description ~= "" then v5:Format(data.description) else nil

		local v7 = not v6 and {} or module(v6)
		local v8

		if data.descriptionBullets and data.descriptionBullets ~= "" then
			v8 = v5:Format(data.descriptionBullets)
		end

		local v9 = not v8 and {} or module(v8)

		local children = {}

		for k, v10 in v7 do
			table.insert(
				children,
				module2.createElement(text, {
					Text = v10,
					tag = "auto-xy text-body-large text-wrap text-align-x-left",
					LayoutOrder = k
				})
			)
		end

		local children2 = {}

		for k, v10 in v9 do
			table.insert(
				children2,
				module2.createElement(view, {
					tag = "row gap-small auto-xy",
					LayoutOrder = k
				}, {
					BulletIcon = module2.createElement(text, {
						Text = "•",
						tag = "auto-xy text-body-large",
						LayoutOrder = 1
					}),
					BulletText = module2.createElement(text, {
						Text = v10,
						tag = "auto-xy text-body-large text-wrap text-align-x-left",
						LayoutOrder = 2
					})
				})
			)
		end

		local createElement = module2.createElement
		local v11 = {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = p2.layoutOrder
		}
		local v12 = {
			Title = module2.createElement(text, {
				Text = v5:Format(data.title),
				tag = "auto-xy text-heading-medium text-wrap text-align-x-left content-emphasis",
				LayoutOrder = 1
			}),
			Subtitle = 0,
			ContentSection = 0
		}

		local v13 = if data.subtitle then module2.createElement(text, {
			Text = v5:Format(data.subtitle),
			tag = "auto-xy text-title-large text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 2
		}) else nil
		v12.Subtitle = v13

		v12.ContentSection = module2.createElement(
			view,
			{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 3 },
			{
				Description = #v7 > 0 and module2.createElement(
					view,
					{ tag = "col gap-medium auto-xy", LayoutOrder = 1 },
					unpack(children)
				),
				Bullets = #v9 > 0 and module2.createElement(
					view,
					{ tag = "col gap-xsmall auto-xy padding-x-large", LayoutOrder = 2 },
					unpack(children2)
				)
			}
		)
		return createElement(view, v11, v12)
	end

	return {
		getIsVisible = function(p2, p3): boolean
			return true
		end,
		renderComponent = module2.memo(PolicyEducationConfig)
	}
end

return createPolicyEducationConfig
