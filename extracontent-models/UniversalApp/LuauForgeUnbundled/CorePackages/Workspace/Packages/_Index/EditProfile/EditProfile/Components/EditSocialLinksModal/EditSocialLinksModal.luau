local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation").Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local EditSocialNetworksItem = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditSocialNetworksItem")
local dropdownMenu = UIBlox.App.Menu.DropdownMenu
local verticalScrollView = UIBlox.App.Container.VerticalScrollView
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useScreenSize
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppNavigation").useNavigationProps
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Types")
local SocialNetworksInEditProfileIXP = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/SocialNetworksInEditProfileIXP")
local FFlagEditProfileFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileFixFocusNavigation")
local FocusNavigatorWrapper = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Utils/FocusNavigatorWrapper")

return function(props)
	local state, setState = React.useState(props.socialNetworks.facebook)
	local state2, setState2 = React.useState(props.socialNetworks.twitter)
	local state3, setState3 = React.useState(props.socialNetworks.youtube)
	local state4, setState4 = React.useState(props.socialNetworks.twitch)
	local state5, setState5 = React.useState(props.socialNetworks.guilded)
	local state6, setState6 = React.useState(props.socialNetworksVisbility)
	local state7, setState7 = React.useState(0)
	local v5 = state6 == Constants.VisibilitySettings.NoOne
	local v6 = useLocalization({
		cancelButtonText = TextKeys.CancelButtonText,
		saveButtonText = TextKeys.SaveButtonText,
		socialNetworks = TextKeys.SocialNetworks,
		Facebook = TextKeys.Facebook,
		X = TextKeys.X,
		YouTube = TextKeys.YouTube,
		Twitch = TextKeys.Twitch,
		Guilded = TextKeys.Guilded,
		FacebookExample = TextKeys.FacebookExample,
		TwitterExample = TextKeys.TwitterExample,
		YouTubeExample = TextKeys.YouTubeExample,
		TwitchExample = TextKeys.TwitchExample,
		GuildedExample = TextKeys.GuildedExample,
		AllUsers = TextKeys.AllUsersDropDown,
		Friends = TextKeys.FriendsDropDown,
		NoOne = TextKeys.NoOneDropDown,
		FriendsFollowingAndFollowers = TextKeys.FriendsFollowingAndFollowersDropDown,
		FriendsAndFollowing = TextKeys.FriendsAndFollowingDropDown,
		VisibleTo = TextKeys.VisibleTo
	})

	local v7 = useNavigationProps(function(p2, p3)
		return { focusOn = p3.focusOn }
	end)

	local v8 = SocialNetworksInEditProfileIXP.useGetExperimentVariant({ isExposureEnabled = true })

	local v9 = useStyle()
	local font = v9.Font
	local theme = v9.Theme
	local v10 = font.BaseSize * font.Body.RelativeSize
	local v11 = useScreenSize()

	local function onSave()
		props.saveOnActivated(state6, state, state2, state3, state4, state5)
	end

	local v12 = React.useCallback(function(p2)
		setState6(p2)
	end, {})

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({ onClose = props.cancelOnActivated }, {
			React.createElement(
				verticalScrollView,
				{
					useAutomaticCanvasSize = true,
					canvasSizeY = UDim.new(),
					elasticBehavior = Enum.ElasticBehavior.Never
				},
				{ React.createElement(interactiveAlert, {
						title = v6.socialNetworks,
						screenSize = v11,
						anchorPoint = Vector2.new(0.5, 0),
						position = UDim2.new(0.5, 0, 0, 30 + state7),
						middleContent = function()
							return React.createElement(
								"Frame",
								{
									BackgroundTransparency = 1,
									AutomaticSize = Enum.AutomaticSize.XY
								},
								{
									UIListLayout = React.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										VerticalAlignment = Enum.VerticalAlignment.Center,
										HorizontalAlignment = Enum.HorizontalAlignment.Left,
										SortOrder = Enum.SortOrder.LayoutOrder
									}),
									Facebook = React.createElement(EditSocialNetworksItem, {
										textChanged = setState,
										networkTitle = v6.Facebook,
										initialText = state,
										placeholderText = v6.FacebookExample,
										layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 1 or 2,
										focusOn = v7.focusOn == 1,
										isVisibilityNoOne = v5,
										setKeyboardOffset = setState7
									}),
									Twitter = React.createElement(EditSocialNetworksItem, {
										textChanged = setState2,
										networkTitle = v6.X,
										initialText = state2,
										placeholderText = v6.TwitterExample,
										layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 2 or 3,
										focusOn = v7.focusOn == 2,
										isVisibilityNoOne = v5,
										setKeyboardOffset = setState7
									}),
									YouTube = React.createElement(EditSocialNetworksItem, {
										textChanged = setState3,
										networkTitle = v6.YouTube,
										initialText = state3,
										placeholderText = v6.YouTubeExample,
										layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 3 or 4,
										focusOn = v7.focusOn == 3,
										isVisibilityNoOne = v5,
										setKeyboardOffset = setState7
									}),
									Twitch = React.createElement(EditSocialNetworksItem, {
										textChanged = setState4,
										networkTitle = v6.Twitch,
										initialText = state4,
										placeholderText = v6.TwitchExample,
										layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 4 or 5,
										focusOn = v7.focusOn == 4,
										isVisibilityNoOne = v5,
										setKeyboardOffset = setState7
									}),
									Guilded = React.createElement(EditSocialNetworksItem, {
										textChanged = setState5,
										networkTitle = v6.Guilded,
										initialText = state5,
										placeholderText = v6.GuildedExample,
										layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 5 or 6,
										focusOn = v7.focusOn == 5,
										isVisibilityNoOne = v5,
										setKeyboardOffset = setState7
									}),
									Visibility = React.createElement("Frame", {
										BackgroundTransparency = 1,
										Size = UDim2.new(1, 0, 0, 0),
										AutomaticSize = Enum.AutomaticSize.Y,
										LayoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 6 or 1,
										ZIndex = 2
									}, {
										UIListLayout = React.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Vertical,
											SortOrder = Enum.SortOrder.LayoutOrder,
											Padding = UDim.new(0, 12)
										}),
										NetworkLabel = React.createElement("TextLabel", {
											LayoutOrder = -1,
											BackgroundTransparency = 1,
											FontFace = normalizeFontFace(v9.Tokens.Typography.BodyLarge.Font),
											Text = v6.VisibleTo,
											TextSize = v10,
											TextColor3 = theme.TextDefault.Color,
											AutomaticSize = Enum.AutomaticSize.XY,
											RichText = true,
											ZIndex = 0
										}),
										Dropdown = React.createElement(dropdownMenu, {
											placeholder = v6[state6],
											onChange = v12,
											screenSize = Vector2.new(math.clamp(v11.X - 48, 272, 400) - 48, 640),
											height = UDim.new(0, v10 + 20),
											dropdownMenuListPositionFixed = true,
											cellDatas = {
												{
													text = v6.AllUsers,
													key = Constants.VisibilitySettings.AllUsers
												},
												{
													text = v6.FriendsFollowingAndFollowers,
													key = Constants.VisibilitySettings.FriendsFollowingAndFollowers
												},
												{
													text = v6.FriendsAndFollowing,
													key = Constants.VisibilitySettings.FriendsAndFollowing
												},
												{
													text = v6.Friends,
													key = Constants.VisibilitySettings.Friends
												},
												{
													text = v6.NoOne,
													key = Constants.VisibilitySettings.NoOne
												}
											},
											showDropShadow = true,
											defaultKey = state6
										})
									})
								}
							)
						end,
						buttonStackInfo = {
							buttons = {
								{
									buttonType = buttonType.Secondary,
									props = {
										onActivated = props.cancelOnActivated,
										text = v6.cancelButtonText
									}
								},
								{
									buttonType = buttonType.PrimarySystem,
									props = {
										onActivated = onSave,
										text = v6.saveButtonText
									}
								}
							},
							buttonHeight = 48,
							marginBetween = 6,
							forcedFillDirection = Enum.FillDirection.Horizontal
						}
					}) }
			)
		})
	end

	return React.createElement(
		verticalScrollView,
		{
			useAutomaticCanvasSize = true,
			canvasSizeY = UDim.new(),
			elasticBehavior = Enum.ElasticBehavior.Never
		},
		{ React.createElement(interactiveAlert, {
				title = v6.socialNetworks,
				screenSize = v11,
				anchorPoint = Vector2.new(0.5, 0),
				position = UDim2.new(0.5, 0, 0, 30 + state7),
				middleContent = function()
					return React.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.XY
						},
						{
							UIListLayout = React.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Facebook = React.createElement(EditSocialNetworksItem, {
								textChanged = setState,
								networkTitle = v6.Facebook,
								initialText = state,
								placeholderText = v6.FacebookExample,
								layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 1 or 2,
								focusOn = v7.focusOn == 1,
								isVisibilityNoOne = v5,
								setKeyboardOffset = setState7
							}),
							Twitter = React.createElement(EditSocialNetworksItem, {
								textChanged = setState2,
								networkTitle = v6.X,
								initialText = state2,
								placeholderText = v6.TwitterExample,
								layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 2 or 3,
								focusOn = v7.focusOn == 2,
								isVisibilityNoOne = v5,
								setKeyboardOffset = setState7
							}),
							YouTube = React.createElement(EditSocialNetworksItem, {
								textChanged = setState3,
								networkTitle = v6.YouTube,
								initialText = state3,
								placeholderText = v6.YouTubeExample,
								layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 3 or 4,
								focusOn = v7.focusOn == 3,
								isVisibilityNoOne = v5,
								setKeyboardOffset = setState7
							}),
							Twitch = React.createElement(EditSocialNetworksItem, {
								textChanged = setState4,
								networkTitle = v6.Twitch,
								initialText = state4,
								placeholderText = v6.TwitchExample,
								layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 4 or 5,
								focusOn = v7.focusOn == 4,
								isVisibilityNoOne = v5,
								setKeyboardOffset = setState7
							}),
							Guilded = React.createElement(EditSocialNetworksItem, {
								textChanged = setState5,
								networkTitle = v6.Guilded,
								initialText = state5,
								placeholderText = v6.GuildedExample,
								layoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 5 or 6,
								focusOn = v7.focusOn == 5,
								isVisibilityNoOne = v5,
								setKeyboardOffset = setState7
							}),
							Visibility = React.createElement("Frame", {
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								LayoutOrder = v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast and 6 or 1,
								ZIndex = 2
							}, {
								UIListLayout = React.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder,
									Padding = UDim.new(0, 12)
								}),
								NetworkLabel = React.createElement("TextLabel", {
									LayoutOrder = -1,
									BackgroundTransparency = 1,
									FontFace = normalizeFontFace(v9.Tokens.Typography.BodyLarge.Font),
									Text = v6.VisibleTo,
									TextSize = v10,
									TextColor3 = theme.TextDefault.Color,
									AutomaticSize = Enum.AutomaticSize.XY,
									RichText = true,
									ZIndex = 0
								}),
								Dropdown = React.createElement(dropdownMenu, {
									placeholder = v6[state6],
									onChange = v12,
									screenSize = Vector2.new(math.clamp(v11.X - 48, 272, 400) - 48, 640),
									height = UDim.new(0, v10 + 20),
									dropdownMenuListPositionFixed = true,
									cellDatas = {
										{
											text = v6.AllUsers,
											key = Constants.VisibilitySettings.AllUsers
										},
										{
											text = v6.FriendsFollowingAndFollowers,
											key = Constants.VisibilitySettings.FriendsFollowingAndFollowers
										},
										{
											text = v6.FriendsAndFollowing,
											key = Constants.VisibilitySettings.FriendsAndFollowing
										},
										{
											text = v6.Friends,
											key = Constants.VisibilitySettings.Friends
										},
										{
											text = v6.NoOne,
											key = Constants.VisibilitySettings.NoOne
										}
									},
									showDropShadow = true,
									defaultKey = state6
								})
							})
						}
					)
				end,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.Secondary,
							props = {
								onActivated = props.cancelOnActivated,
								text = v6.cancelButtonText
							}
						},
						{
							buttonType = buttonType.PrimarySystem,
							props = { onActivated = onSave, text = v6.saveButtonText }
						}
					},
					buttonHeight = 48,
					marginBetween = 6,
					forcedFillDirection = Enum.FillDirection.Horizontal
				}
			}) }
	)
end
