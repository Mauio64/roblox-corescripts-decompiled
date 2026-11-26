local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local image = Foundation.Image
local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/bundled/ciE").Utils.getStandardSizeAvatarHeadShotRbxthumb

local function SafetySupportProfileHeader(p2)
	local v5 = useTokens()

	local v6 = useSelector(function(p3)
		return p3.Users[p3.LocalUserId]
	end)

	if not v6 then
		return nil
	end

	local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb(v6.id)
	local displayName = v6.displayName or ""
	local name = v6.name or ""
	local v7 = displayName ~= "" or name ~= ""
	local createElement = React.createElement
	local v9 = {
		tag = "col align-x-center align-y-center gap-large size-full-0 auto-y padding-large",
		LayoutOrder = p2.LayoutOrder
	}
	local v10 = {
		Avatar = React.createElement(image, {
			Image = standardSizeAvatarHeadShotRbxthumb,
			Size = UDim2.fromOffset(v5.Size.Size_1600, v5.Size.Size_1600),
			tag = "radius-circle bg-shift-300",
			LayoutOrder = 1
		}),
		UsernameContainer = 0
	}

	if v7 then
		v7 = React.createElement(
			view,
			{
				tag = "col align-x-center gap-xxsmall size-full-0 auto-y",
				LayoutOrder = 2
			},
			{
				DisplayName = displayName ~= "" and React.createElement(text, {
					tag = "auto-xy text-title-large content-emphasis",
					Text = displayName,
					LayoutOrder = 1
				}),
				UserName = name ~= "" and React.createElement(text, {
					tag = "auto-xy text-label-medium",
					Text = "@" .. name,
					LayoutOrder = 2
				})
			}
		)
	end

	v10.UsernameContainer = v7
	return createElement(view, v9, v10)
end

return SafetySupportProfileHeader
