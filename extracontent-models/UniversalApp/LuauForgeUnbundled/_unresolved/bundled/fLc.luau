local module = require("@luauforge/bundled/fJc")
local module2 = require("@luauforge/bundled/fKe")
local module3 = require("@luauforge/bundled/fJe")

local useRoactService = require("@luauforge/bundled/fJu").useRoactService

local roactNetworking = require("@luauforge/bundled/fJv").RoactNetworking

local view = module2.View
local text = module2.Text
local useTokens = module2.Hooks.useTokens
local loadableImage = module3.App.Loading.LoadableImage

local logger = require("@luauforge/bundled/fJr").Logger

local getUserById = require("@luauforge/bundled/fJy").Thunks.GetUserById

local getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/bundled/fKu").Utils.getStandardSizeAvatarHeadShotRbxthumb

return function(props)
	local v5 = useTokens()
	local v6 = useRoactService(roactNetworking)

	local state, setState = module.useState("")
	local state2, setState2 = module.useState("")

	module.useEffect(function()
		getUserById(v6, `{props.userId}`):andThen(function(p2)
			setState2(p2.name)
			setState(p2.displayName)
		end):catch(function(p2)
			logger:warning("Error getting user info: {}", p2)
		end)
	end, {})

	return module.createElement(view, {
		LayoutOrder = props.index,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		onActivated = function()
			props.onProfileActivated(props.userId)
		end
	}, {
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Size.Size_300),
			PaddingBottom = UDim.new(0, v5.Size.Size_300)
		}),
		HorizontalLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.Size.Size_400)
		}),
		AvatarImage = module.createElement(loadableImage, {
			LayoutOrder = 1,
			Size = UDim2.new(0, 48, 0, 48),
			Image = getStandardSizeAvatarHeadShotRbxthumb(`{props.userId}`),
			useShimmerAnimationWhileLoading = true,
			cornerRadius = UDim.new(0.5, 0),
			shouldHandleReloads = true
		}),
		UsernameAndDisplayName = module.createElement(
			view,
			{
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left
				}),
				DisplayName = module.createElement(text, {
					Text = state,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					fontStyle = v5.Typography.TitleMedium,
					textStyle = v5.Color.Content.Emphasis,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				}),
				Username = module.createElement(text, {
					Text = "@" .. state2,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					fontStyle = v5.Typography.BodyMedium,
					textStyle = v5.Color.Content.Default,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				})
			}
		)
	})
end
