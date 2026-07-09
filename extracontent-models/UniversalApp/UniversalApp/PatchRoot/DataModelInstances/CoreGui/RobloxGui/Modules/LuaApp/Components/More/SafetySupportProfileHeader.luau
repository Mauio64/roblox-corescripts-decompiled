local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationImage = Foundation.Image
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local getStandardSizeAvatarHeadShotRbxthumb = require(CorePackages.Workspace.Packages.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb

local function SafetySupportProfileHeader(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), useSelector (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), React (copy), View (copy), FoundationImage (copy), FoundationText (copy)
	local v12 = useTokens()
	local v13 = useSelector(function(p1) -- line: 22
		return p1.Users[p1.LocalUserId]
	end)

	if not v13 then
		return nil
	end

	local v14 = getStandardSizeAvatarHeadShotRbxthumb(v13.id)
	local v15 = v13.displayName or ""
	local v16 = v13.name or ""
	local v17 = v15 ~= "" or v16 ~= ""

	return React.createElement(View, {
		tag = "col align-x-center align-y-center gap-large size-full-0 auto-y padding-large",
		LayoutOrder = t1.LayoutOrder
	}, {
		Avatar = React.createElement(FoundationImage, {
			tag = "radius-circle bg-shift-300",
			LayoutOrder = 1,
			Image = v14,
			Size = UDim2.fromOffset(v12.Size.Size_1600, v12.Size.Size_1600)
		}),
		UsernameContainer = v17 and React.createElement(View, {
			tag = "col align-x-center gap-xxsmall size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			DisplayName = v15 ~= "" and React.createElement(FoundationText, {
				tag = "auto-xy text-title-large content-emphasis",
				LayoutOrder = 1,
				Text = v15
			}),
			UserName = v16 ~= "" and React.createElement(FoundationText, {
				tag = "auto-xy text-label-medium",
				LayoutOrder = 2,
				Text = "@" .. v16
			})
		})
	})
end

return SafetySupportProfileHeader
