local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ContactList = CoreGui:WaitForChild("RobloxGui").Modules.ContactList
local dependencies = require(ContactList.dependencies)
local Pages = require(ContactList.Enums.Pages)
local SetCurrentPage = require(ContactList.Actions.SetCurrentPage)
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local UIBlox = dependencies.UIBlox
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useStyle = UIBlox.Core.Style.useStyle

return function(t1: {[any]: any}) -- line: 42
	-- upvalues: useAnalytics (copy), useStyle (copy), useDispatch (copy), useLocalization (copy), Pages (copy), React (copy), EventNamesEnum (copy), SetCurrentPage (copy), ImageSetButton (copy), Images (copy)
	local v18 = useAnalytics()
	local v19 = useStyle()
	local v20 = useDispatch()
	local Theme = v19.Theme
	local Font = v19.Font
	local v23 = useLocalization
	local t2 = {}
	local currentPage = t1.currentPage

	t2.titleLabel = if currentPage ~= Pages.FriendList then currentPage ~= Pages.CallHistory and "" or "Feature.Call.Label.RecentCalls" else "Feature.Call.Label.StartNewCall"

	local v26 = v23(t2)
	local v27 = React.useCallback(function() -- line: 53
		-- upvalues: v18 (copy), EventNamesEnum (copy), t1 (copy), Pages (copy), v20 (copy), SetCurrentPage (copy)
		v18.fireEvent(EventNamesEnum.PhoneBookNavigate, {
			eventTimestampMs = os.time() * 1000,
			startingPage = t1.currentPage,
			destinationPage = Pages.CallHistory
		})
		v20(SetCurrentPage(Pages.CallHistory))
	end, { t1.currentPage })
	local v28 = React.useCallback(function() -- line: 62
		-- upvalues: v18 (copy), EventNamesEnum (copy), t1 (copy), Pages (copy), v20 (copy), SetCurrentPage (copy)
		v18.fireEvent(EventNamesEnum.PhoneBookNavigate, {
			eventTimestampMs = os.time() * 1000,
			startingPage = t1.currentPage,
			destinationPage = Pages.FriendList
		})
		v20(SetCurrentPage(Pages.FriendList))
	end, { t1.currentPage })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, t1.headerHeight),
		LayoutOrder = t1.layoutOrder
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		}),
		HeaderUIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		DismissButton = React.createElement(ImageSetButton, {
			Size = UDim2.fromOffset(32, 32),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			Image = if t1.currentPage ~= Pages.CallHistory then Images["icons/navigation/pushBack"] else Images["icons/navigation/close"],
			LayoutOrder = 1,
			[React.Event.Activated] = if t1.currentPage ~= Pages.CallHistory then v27 else t1.dismissCallback
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			})
		}),
		DividerContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Divider = React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, 1, 0, 16),
				BackgroundColor3 = Theme.Divider.Color,
				BackgroundTransparency = Theme.Divider.Transparency
			}),
			DividerContainerUIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 12)
			})
		}),
		HeaderText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, -85, 0, 24),
			Font = Font.Header1.Font,
			Text = v26.titleLabel,
			TextColor3 = Theme.TextEmphasis.Color,
			TextSize = Font.Header1.RelativeSize * Font.BaseSize,
			TextTransparency = Theme.TextEmphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		NewCallButton = if t1.currentPage ~= Pages.CallHistory then nil else React.createElement(ImageSetButton, {
			Size = UDim2.fromOffset(32, 32),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			Image = "rbxassetid://15239778003",
			LayoutOrder = 4,
			[React.Event.Activated] = v28
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			})
		})
	})
end
