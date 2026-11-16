local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local module = require("@luauforge/bundled/dTM")
local module2 = require("@luauforge/deferred/gfb")
local module3 = require("@luauforge/deferred/gfc")

local UIBlox = require(CorePackages.Packages.UIBlox)
local modalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local Foundation = require(CorePackages.Packages.Foundation)
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local inputSize = Foundation.Enums.InputSize
local fillBehavior = Foundation.Enums.FillBehavior

local function createSectionList(sections, p2)
	if not sections then
		return nil
	end

	local children = {}

	for k in sections do
		table.insert(
			children,
			React.createElement(view, {
				tag = "col gap-small size-full-0 auto-y",
				LayoutOrder = k
			}, {
				Heading = React.createElement(text, {
					tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis",
					Text = p2["heading" .. k],
					LayoutOrder = 1
				}),
				Body = React.createElement(text, {
					tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default",
					Text = p2["body" .. k],
					RichText = true,
					LayoutOrder = 2
				})
			})
		)
	end

	return React.createElement(
		view,
		{ tag = "col gap-large size-full-0 auto-y", LayoutOrder = 3 },
		children
	)
end

function LUAUFORGE_MODULE_GLOBALS_giA_ItemInfoRowPrompt(props)
	local v5 = useLocalization((React.useMemo(function()
		local result = {
			confirmButtonText = props.confirmButtonText,
			message = props.message,
			title = props.title
		}

		if props.sections then
			for k, section in props.sections do
				result["heading" .. k] = section.heading
				result["body" .. k] = section.body
			end
		end

		return result
	end, { props.message, props.title, props.confirmButtonText, props.sections })))

	local sectionList = createSectionList(props.sections, v5)

	local v6 = React.useCallback(function()
		module.closeFocusedScreen(props.navigation)
	end, { props.navigation })

	local function fn()
		local createElement = React.createElement

		local v11 = if props.title then React.createElement(text, {
			tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis",
			Text = v5.title,
			RichText = true,
			LayoutOrder = 1
		}) else nil

		local v12 = if props.message then React.createElement(text, {
			tag = "size-full-0 auto-y text-align-x-left text-body-large text-wrap",
			Text = v5.message,
			RichText = true,
			LayoutOrder = 2
		}) else nil
		return {
			container = createElement(view, {
				tag = "size-full-0 auto-y padding-xlarge col gap-large"
			}, {
				Title = v11,
				Text = v12,
				SectionList = sectionList,
				Footer = React.createElement(view, {
					tag = "row size-full-0 auto-y",
					LayoutOrder = 4
				}, {
					Button = React.createElement(button, {
						tag = "size-full-0 auto-y",
						fillBehavior = fillBehavior.Fill,
						text = v5.confirmButtonText,
						size = inputSize.Large,
						onActivated = v6
					})
				})
			})
		}
	end

	return React.createElement(modalWindow, {
		screenSize = props.screenSize,
		isFullHeight = false
	}, fn())
end

return module3(module2(LUAUFORGE_MODULE_GLOBALS_giA_ItemInfoRowPrompt))
