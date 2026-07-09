local Parent = script:FindFirstAncestor("AccountRecovery").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local UIBlox = require(Parent.UIBlox)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local LoadableImage = UIBlox.App.Loading.LoadableImage
local Logger = require(Parent.Loggers).Logger
local GetUserById = require(Parent.AuthCommon).Thunks.GetUserById
local getStandardSizeAvatarHeadShotRbxthumb = require(Parent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb

return function(t1: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), useRoactService (copy), RoactNetworking (copy), React (copy), GetUserById (copy), Logger (copy), View (copy), LoadableImage (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), FoundationText (copy)
	local v15 = useTokens()
	local v16 = useRoactService(RoactNetworking)
	local v17, v18 = React.useState("")
	local v19, v20 = React.useState("")

	React.useEffect(function() -- line: 38
		-- upvalues: GetUserById (copy), v16 (copy), t1 (copy), v20 (copy), v18 (copy), Logger (copy)
		GetUserById(v16, `{ t1.userId }`):andThen(function(p1) -- line: 39
			-- upvalues: v20 (copy), v18 (copy)
			v20(p1.name)
			v18(p1.displayName)
		end):catch(function(p2) -- line: 42
			-- upvalues: Logger (copy)
			Logger:warning("Error getting user info: {}", p2)
		end)
	end, {})

	return React.createElement(View, {
		BackgroundTransparency = 1,
		LayoutOrder = t1.index,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		onActivated = function() -- line: 52
			-- upvalues: t1 (copy)
			t1.onProfileActivated(t1.userId)
		end
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v15.Size.Size_300),
			PaddingBottom = UDim.new(0, v15.Size.Size_300)
		}),
		HorizontalLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v15.Size.Size_400)
		}),
		AvatarImage = React.createElement(LoadableImage, {
			LayoutOrder = 1,
			useShimmerAnimationWhileLoading = true,
			shouldHandleReloads = true,
			Size = UDim2.new(0, 48, 0, 48),
			Image = getStandardSizeAvatarHeadShotRbxthumb(`{ t1.userId }`),
			cornerRadius = UDim.new(0.5, 0)
		}),
		UsernameAndDisplayName = React.createElement(View, {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			DisplayName = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = v17,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				fontStyle = v15.Typography.TitleMedium,
				textStyle = v15.Color.Content.Emphasis,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			}),
			Username = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = "@" .. v19,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				fontStyle = v15.Typography.BodyMedium,
				textStyle = v15.Color.Content.Default,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	})
end
