local Parent = script:FindFirstAncestor("LandingPage").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Enums = Foundation.Enums
local UserLib = require(Parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
local useLocalization = require(Parent.Localization).Hooks.useLocalization

require(script.Parent.AccountCarouselAvatar)

local GetFFlagEnableManageAccountsRedesign = require(Parent.SharedFlags).GetFFlagEnableManageAccountsRedesign

return function(t1: {[any]: any}) -- line: 20
	-- upvalues: useLocalization (copy), GetFFlagEnableManageAccountsRedesign (copy), React (copy), Foundation (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Enums (copy)
	local v11 = useLocalization({
		signedOut = "Authentication.AccountPicker.Label.SignedOut"
	})
	local v12 = GetFFlagEnableManageAccountsRedesign() and t1.enableSignedOutAccounts
	local t2 = {}

	if #t1.accounts == 0 then
		t1.onClose()
	end

	for i, v in ipairs(t1.accounts) do
		local username = v.username

		if username == nil then
			username = ""
		end

		t2[i] = React.createElement(Foundation.View, {
			tag = {
				["size-full-0 auto-y items-center padding-bottom-small"] = true,
				col = v12,
				["row padding-x-small"] = not v12
			},
			LayoutOrder = i
		}, {
			AccountCard = React.createElement(Foundation.View, {
				BackgroundTransparency = 1,
				tag = {
					["row size-full-0 auto-y wrap gap-medium radius-medium align-y-center"] = true,
					["padding-y-small padding-left-small"] = v12,
					["padding-y-medium padding-left-medium"] = not v12
				}
			}, {
				Avatar = React.createElement(Foundation.View, {
					tag = "col shrink size-1200-1200 radius-full self-center",
					LayoutOrder = 0
				}, {
					AvatarContainer = React.createElement(Foundation.View, {
						tag = "radius-circle bg-surface-200",
						Size = UDim2.new(0, 48, 0, 48)
					}, {
						AvatarImage = React.createElement(Foundation.Image, {
							tag = "radius-circle",
							Size = UDim2.new(1, 0, 1, 0),
							Image = getRbxthumbWithTypeSizeAndOptions(tostring(v.user_id), Constants.RbxthumbTypes.AvatarHeadShot, 150)
						})
					})
				}),
				AccountInfo = React.createElement(Foundation.View, {
					tag = "col fill auto-y items-start",
					LayoutOrder = 1
				}, {
					DisplayName = React.createElement(Foundation.Text, {
						tag = "auto-y size-full-0 text-title-large text-align-x-left",
						LayoutOrder = 0,
						Text = v.display_name or username,
						TextTruncate = Enum.TextTruncate.SplitWord
					}),
					Username = React.createElement(Foundation.Text, {
						tag = "auto-y size-full-0 text-body-small text-align-x-left",
						LayoutOrder = 1,
						Text = "@" .. username,
						TextTruncate = Enum.TextTruncate.SplitWord
					})
				}),
				SignedOutPill = if not v12 or v.has_valid_session then nil else React.createElement(Foundation.View, {
					tag = "col auto-xy padding-x-small padding-y-xsmall radius-small bg-action-alert",
					LayoutOrder = 2
				}, {
					PillText = React.createElement(Foundation.Text, {
						tag = "auto-xy text-caption-large text-align-x-center text-title-medium",
						Text = v11.signedOut
					})
				}),
				DeleteButton = React.createElement(Foundation.View, {
					tag = "col auto-xy size-full-0 items-end",
					LayoutOrder = 3
				}, {
					DeleteIcon = React.createElement(Foundation.IconButton, {
						icon = Enums.IconName.TrashCan,
						size = Enums.InputSize.Medium,
						onActivated = function() -- line: 107
							-- upvalues: t1 (copy), v (copy)
							t1.setRemoveAccount(v)
						end
					})
				})
			})
		})
	end

	if v12 then
		return React.createElement(React.Fragment, nil, t2)
	end

	return React.createElement(Foundation.View, {
		tag = "col auto-xy size-full-0 auto-y padding-small"
	}, {
		ScrollView = React.createElement(Foundation.ScrollView, {
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.XY,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None
			},
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			AccountElements = React.createElement(Foundation.View, {
				tag = "col auto-x size-full-0",
				LayoutOrder = 2
			}, t2)
		})
	})
end
