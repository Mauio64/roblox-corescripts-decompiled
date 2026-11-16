local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Foundation")
local view = Foundation.View
local text = Foundation.Text
local avatar = Foundation.Avatar
local button = Foundation.Button
local textInput = Foundation.TextInput
local searchInput = Foundation.SearchInput
local toggle = Foundation.Toggle
local chip = Foundation.Chip
local menu = Foundation.Menu
local scrollView = Foundation.ScrollView
local useTokens = Foundation.Hooks.useTokens
local dialog = Foundation.Dialog
local avatarSize = Foundation.Enums.AvatarSize
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local iconName = Foundation.Enums.IconName
local inputFocusBehavior = Foundation.Enums.InputFocusBehavior
local inputSize = Foundation.Enums.InputSize
local orientation = Foundation.Enums.Orientation

local function renderPlayerRow(p2, props, k)
	local createElement = React.createElement

	local v7 = {
		Avatar = React.createElement(avatar, {
			userId = props.userId,
			size = avatarSize.Small,
			LayoutOrder = 1
		}),
		Name = React.createElement(text, {
			Text = props.displayName,
			tag = "fill auto-xy text-body-medium text-align-x-left text-truncate-end content-default",
			LayoutOrder = 2
		}),
		AddButton = 0
	}

	local createElement2 = React.createElement
	local v9 = {
		testId = `--purchase-prompt-button-add-player-{props.userId}`,
		text = p2.locales.add,
		icon = 0,
		variant = 0,
		size = 0,
		onActivated = 0,
		LayoutOrder = 3
	}
	local v10 = if props.isAdded then iconName.Check else iconName.PlusLarge
	v9.icon = v10
	local v11 = if props.isAdded then buttonVariant.SoftEmphasis else buttonVariant.Standard
	v9.variant = v11
	v9.size = inputSize.Small
	v9.onActivated = props.onToggleAdded
	v7.AddButton = createElement2(button, v9)
	return createElement(
		view,
		{ tag = "row align-y-center gap-medium size-full-0 auto-y", LayoutOrder = k },
		v7
	)
end

local function renderPlayerList(props)
	local children = {}

	for k, player in props.players do
		children[`Player{player.userId}`] = renderPlayerRow(props, player, k)
	end

	if #props.players == 0 then
		children.Empty = React.createElement(text, {
			Text = props.locales.noOne,
			tag = "auto-xy text-body-medium text-align-x-left content-muted"
		})
	end

	children.MaxHeight = React.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(1e999, 180)
	})

	return children
end

local function renderAddedPlayerChips(props)
	if #props.addedPlayers == 0 then
		return nil
	end

	local children = {}

	for k, addedPlayer in props.addedPlayers do
		children[`Added{addedPlayer.userId}`] = React.createElement(chip, {
			testId = `--purchase-prompt-chip-added-player-{addedPlayer.userId}`,
			text = addedPlayer.displayName,
			leading = {
				type = "AvatarGroup",
				props = {
					avatars = { addedPlayer.userId }
				}
			},
			trailing = iconName.X,
			onActivated = addedPlayer.onRemove,
			LayoutOrder = k
		})
	end

	return React.createElement(
		view,
		{ tag = "row wrap gap-small size-full-0 auto-y", LayoutOrder = 3 },
		children
	)
end

local function PeopleSearch(p2)
	local viewProps = p2.viewProps
	local ref = React.useRef(nil)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(false)

	local searchResults = viewProps.searchResults
	local onSearchTextChanged = viewProps.onSearchTextChanged

	local v5 = React.useMemo(function()
		local result = {}

		for k, searchResult in searchResults do
			table.insert(result, {
				id = searchResult.userId,
				text = searchResult.displayName,
				leading = { type = "Avatar", userId = searchResult.userId }
			})
		end

		return result
	end, { searchResults })

	local v6 = React.useCallback(function(p3)
		for k, searchResult in searchResults do
			if searchResult.userId == p3 then
				searchResult.onSelected()
				break
			end
		end
	end, { searchResults })

	local v7 = React.useCallback(function(p3)
		setState2(false)
		onSearchTextChanged(p3)
	end, { onSearchTextChanged })

	local v8 = React.useCallback(function()
		setState2(true)
	end, {})

	local v9 = React.useCallback(function(p3)
		setState(p3.AbsoluteSize.X)
	end, {})

	return React.createElement(
		view,
		{
			tag = "size-full-0 auto-y",
			ref = ref,
			onAbsoluteSizeChanged = v9,
			LayoutOrder = p2.LayoutOrder
		},
		{
			Search = React.createElement(searchInput, {
				testId = "--purchase-prompt-searchinput-people",
				text = viewProps.searchText,
				placeholder = viewProps.locales.searchPeople,
				onChanged = v7,
				width = UDim.new(1, 0)
			}),
			Results = React.createElement(menu, {
				testId = "--purchase-prompt-menu-search-results",
				isOpen = #v5 > 0 and not state2,
				items = v5,
				anchorRef = ref,
				width = UDim.new(0, state),
				maxHeight = 240,
				onPressedOutside = v8,
				onActivated = v6
			})
		}
	)
end

local function renderPrivateServerLink(props)
	local createElement = React.createElement

	local createElement2 = React.createElement

	local v9 = {
		Text = React.createElement(view, {
			tag = "col fill gap-xsmall auto-y",
			LayoutOrder = 1
		}, {
			Heading = React.createElement(text, {
				Text = props.locales.privateServerLink,
				tag = "auto-xy text-heading-small content-emphasis",
				LayoutOrder = 1
			}),
			Description = React.createElement(text, {
				Text = props.locales.anyoneWithThisLinkCanJoin,
				tag = "auto-xy text-body-small content-muted",
				LayoutOrder = 2
			})
		}),
		Generate = 0
	}

	local v10 = if props.link == nil then React.createElement(button, {
		testId = "--purchase-prompt-button-generate-link",
		text = props.locales.generate,
		variant = buttonVariant.Standard,
		size = inputSize.Small,
		isLoading = props.isGeneratingLink,
		onActivated = props.onGenerateLink,
		LayoutOrder = 2
	}) else nil
	v9.Generate = v10
	local children = {
		Header = createElement2(
			view,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y",
				LayoutOrder = 1
			},
			v9
		),
		Field = 0
	}

	local createElement3 = React.createElement
	local v12 = {
		testId = "--purchase-prompt-textinput-link",
		label = "",
		text = props.linkText,
		placeholder = props.locales.generateLinkPlaceholder,
		onChanged = props.onLinkTextChanged,
		isDisabled = props.link == nil,
		focusBehavior = inputFocusBehavior.Highlight,
		iconTrailing = 0,
		width = 0,
		LayoutOrder = 2
	}
	local v13

	if props.link then
		v13 = { name = 0, onActivated = 0 }
		local v14 = if props.isLinkCopied then iconName.Check else iconName.TwoStackedSquares
		v13.name = v14
		v13.onActivated = props.onCopyLink
	end

	v12.iconTrailing = v13

	v12.width = UDim.new(1, 0)
	children.Field = createElement3(textInput, v12)
	return createElement(view, {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = 4
	}, children)
end

local function VIPServerConfigurationView(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local root = dialog.Root
	local v6 = {
		size = dialogSize.Medium,
		onClose = 0,
		disablePortal = true,
		testId = "VIPServerConfigurationView"
	}

	local v7 = if not props.isSaving then props.onCancel else nil
	v6.onClose = v7

	local children = {
		Title = React.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = props.locales.title
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content

	local createElement3 = React.createElement

	local v12 = {
		ServerName = React.createElement(textInput, {
			testId = "--purchase-prompt-textinput-server-name",
			label = props.locales.serverName,
			text = props.serverName,
			onChanged = props.onServerNameChanged,
			width = UDim.new(1, 0),
			LayoutOrder = 1
		}),
		WhoCanJoin = React.createElement(
			view,
			{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 2 },
			{
				Heading = React.createElement(text, {
					Text = props.locales.whoCanJoin,
					tag = "auto-xy text-heading-small content-emphasis",
					LayoutOrder = 1
				}),
				Search = React.createElement(PeopleSearch, {
					viewProps = props,
					LayoutOrder = 2
				}),
				AddedPlayers = renderAddedPlayerChips(props),
				InThisServer = React.createElement(text, {
					Text = props.locales.inThisServer,
					tag = "auto-xy text-title-small content-default",
					LayoutOrder = 4
				}),
				PlayerList = React.createElement(scrollView, {
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					layout = {
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v5.Gap.Small)
					},
					scroll = {
						ScrollingDirection = Enum.ScrollingDirection.Y,
						AutomaticSize = Enum.AutomaticSize.Y,
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.fromScale(0, 0)
					},
					LayoutOrder = 5
				}, renderPlayerList(props))
			}
		),
		FriendsAllowed = React.createElement(
			view,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y",
				LayoutOrder = 3
			},
			{
				Text = React.createElement(
					view,
					{ tag = "col fill gap-xxsmall auto-y", LayoutOrder = 1 },
					{
						Label = React.createElement(text, {
							Text = props.locales.friendsAllowed,
							tag = "auto-xy text-body-medium content-emphasis",
							LayoutOrder = 1
						}),
						Description = React.createElement(text, {
							Text = props.locales.friendsAllowedDescription,
							tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-muted",
							LayoutOrder = 2
						})
					}
				),
				Toggle = React.createElement(toggle, {
					testId = "--purchase-prompt-toggle-friends-allowed",
					label = "",
					isChecked = props.friendsAllowed,
					onActivated = props.onFriendsAllowedChanged,
					LayoutOrder = 2
				})
			}
		),
		PrivateServerLink = renderPrivateServerLink(props),
		Error = 0
	}
	local v13 = if props.hasError then React.createElement(text, {
		testId = "--purchase-prompt-text-error",
		Text = props.locales.somethingWentWrong,
		tag = "auto-xy text-body-medium content-system-alert",
		LayoutOrder = 5
	}) else nil
	v12.Error = v13
	children.Content = createElement2(content, { LayoutOrder = 2 }, {
		Body = createElement3(view, { tag = "col gap-large size-full-0 auto-y" }, v12)
	})

	children.Actions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		orientation = orientation.Horizontal,
		actions = {
			{
				testId = "--purchase-prompt-button-continue",
				text = props.locales.continue,
				variant = buttonVariant.Emphasis,
				onActivated = props.onSave,
				isLoading = props.isSaving
			}
		}
	})
	return createElement(root, v6, children)
end

return VIPServerConfigurationView
