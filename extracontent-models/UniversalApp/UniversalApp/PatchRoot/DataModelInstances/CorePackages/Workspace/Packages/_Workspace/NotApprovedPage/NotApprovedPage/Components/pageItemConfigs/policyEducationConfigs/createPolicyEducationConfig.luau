local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)

local splitByNewlines = require(NotApprovedPage.Utils.splitByNewlines)

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local Localization = require(NotApprovedPageParent.RobloxAppLocales).Localization
local LocalizationService = game:GetService("LocalizationService")
local v10 = Localization.new(LocalizationService.RobloxLocaleId)

local function createPolicyEducationConfig(t1: {[any]: any}) -- line: 41
	-- upvalues: v10 (copy), splitByNewlines (copy), React (copy), FoundationText (copy), View (copy)
	local function PolicyEducationConfig(p1) -- line: 42
		-- upvalues: v10 (copy), t1 (copy), splitByNewlines (copy), React (copy), FoundationText (copy), View (copy)
		local v15 = v10:Format(t1.description)
		local v16 = if not v15 then {} else splitByNewlines(v15)
		local v17 = if not t1.descriptionBullets or t1.descriptionBullets == "" then nil else v10:Format(t1.descriptionBullets)
		local v18 = if not v17 then {} else splitByNewlines(v17)
		local t2 = {}

		for v20, v21 in v16 do
			table.insert(t2, React.createElement(FoundationText, {
				tag = "auto-xy text-body-large text-align-x-left text-wrap",
				Text = v21,
				LayoutOrder = v20
			}))
		end

		local t3 = {}

		for v23, v24 in v18 do
			table.insert(t3, React.createElement(View, {
				tag = "auto-xy row gap-small",
				LayoutOrder = v23
			}, {
				BulletIcon = React.createElement(FoundationText, {
					Text = "•",
					tag = "auto-xy text-body-large",
					LayoutOrder = 1
				}),
				BulletText = React.createElement(FoundationText, {
					tag = "auto-xy text-body-large text-wrap text-align-x-left",
					LayoutOrder = 2,
					Text = v24
				})
			}))
		end

		return React.createElement(View, {
			tag = "col size-full-0 auto-y gap-medium",
			LayoutOrder = p1.layoutOrder
		}, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-medium content-emphasis text-align-x-left text-wrap",
				LayoutOrder = 1,
				Text = v10:Format(t1.title)
			}),
			Subtitle = if not t1.subtitle then nil else React.createElement(FoundationText, {
				tag = "auto-xy text-title-large content-emphasis text-align-x-left text-wrap",
				LayoutOrder = 2,
				Text = v10:Format(t1.subtitle)
			}),
			ContentSection = React.createElement(View, {
				tag = "col size-full-0 auto-y gap-small",
				LayoutOrder = 3
			}, {
				Description = #v16 > 0 and React.createElement(View, {
					tag = "auto-xy col gap-medium",
					LayoutOrder = 1
				}, unpack(t2)),
				Bullets = #v18 > 0 and React.createElement(View, {
					tag = "auto-xy col gap-xsmall padding-x-large",
					LayoutOrder = 2
				}, unpack(t3))
			})
		})
	end

	return {
		getIsVisible = function(_, _: number?) -- line: 125
			return true
		end,
		renderComponent = React.memo(PolicyEducationConfig)
	}
end

return createPolicyEducationConfig
