local parent = script:FindFirstAncestor("PurchasePrompt").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Avatar = Foundation.Avatar
local Button = Foundation.Button
local TextInput = Foundation.TextInput
local SearchInput = Foundation.SearchInput
local Toggle = Foundation.Toggle
local Chip = Foundation.Chip
local Menu = Foundation.Menu
local ScrollView = Foundation.ScrollView
local useTokens = Foundation.Hooks.useTokens
local Dialog = Foundation.Dialog
local AvatarSize = Foundation.Enums.AvatarSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local IconName = Foundation.Enums.IconName
local InputFocusBehavior = Foundation.Enums.InputFocusBehavior
local InputSize = Foundation.Enums.InputSize
local Orientation = Foundation.Enums.Orientation

local function renderPlayerRow(p, props, k: number)
	local createElement = React.createElement

	local v = {
		Avatar = React.createElement(Avatar, {
			userId = props.userId,
			size = AvatarSize.Small,
			LayoutOrder = 1
		}),
		Name = React.createElement(Text, {
			Text = props.displayName,
			tag = "fill auto-xy text-body-medium text-align-x-left text-truncate-end content-default",
			LayoutOrder = 2
		}),
		AddButton = 0
	}

	local createElement2 = React.createElement
	local v2 = {
		testId = `--purchase-prompt-button-add-player-{props.userId}`,
		text = p.locales.add,
		icon = 0,
		variant = 0,
		size = 0,
		onActivated = 0,
		LayoutOrder = 3
	}
	local icon

	if props.isAdded then
		icon = IconName.Check
	else
		icon = IconName.PlusLarge
	end

	v2.icon = icon
	local variant

	if props.isAdded then
		variant = ButtonVariant.SoftEmphasis
	else
		variant = ButtonVariant.Standard
	end

	v2.variant = variant
	v2.size = InputSize.Small
	v2.onActivated = props.onToggleAdded
	v.AddButton = createElement2(Button, v2)
	return createElement(View, {
		tag = "row align-y-center gap-medium size-full-0 auto-y",
		LayoutOrder = k
	}, v)
end

local function renderPlayerList(props)
	local children = {}

	for k, player in props.players do
		children[`Player{player.userId}`] = renderPlayerRow(props, player, k)
	end

	if #props.players == 0 then
		children.Empty = React.createElement(Text, {
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
		children[`Added{addedPlayer.userId}`] = React.createElement(Chip, {
			testId = `--purchase-prompt-chip-added-player-{addedPlayer.userId}`,
			text = addedPlayer.displayName,
			leading = {
				type = "AvatarGroup",
				props = {
					avatars = { addedPlayer.userId }
				}
			},
			trailing = IconName.X,
			onActivated = addedPlayer.onRemove,
			LayoutOrder = k
		})
	end

	return React.createElement(View, {
		tag = "row wrap gap-small size-full-0 auto-y",
		LayoutOrder = 3
	}, children)
end

local function PeopleSearch(p)
	local viewProps = p.viewProps
	local ref = React.useRef(nil)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(false)

	local searchResults = viewProps.searchResults
	local onSearchTextChanged = viewProps.onSearchTextChanged

	local items = React.useMemo(function()
		local result = {}

		for _, searchResult in searchResults do
			table.insert(result, {
				id = searchResult.userId,
				text = searchResult.displayName,
				leading = { type = "Avatar", userId = searchResult.userId }
			})
		end

		return result
	end, { searchResults })

	local onActivated = React.useCallback(function(p2)
		for _, searchResult in searchResults do
			if searchResult.userId == p2 then
				searchResult.onSelected()
				break
			end
		end
	end, { searchResults })

	local onChanged = React.useCallback(function(p2: string)
		setState2(false)
		onSearchTextChanged(p2)
	end, { onSearchTextChanged })

	local onPressedOutside = React.useCallback(function()
		setState2(true)
	end, {})

	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		setState(p2.AbsoluteSize.X)
	end, {})

	return React.createElement(
		View,
		{
			tag = "size-full-0 auto-y",
			ref = ref,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			LayoutOrder = p.LayoutOrder
		},
		{
			Search = React.createElement(SearchInput, {
				testId = "--purchase-prompt-searchinput-people",
				text = viewProps.searchText,
				placeholder = viewProps.locales.searchPeople,
				onChanged = onChanged,
				width = UDim.new(1, 0)
			}),
			Results = React.createElement(Menu, {
				testId = "--purchase-prompt-menu-search-results",
				isOpen = #items > 0 and not state2,
				items = items,
				anchorRef = ref,
				width = UDim.new(0, state),
				maxHeight = 240,
				onPressedOutside = onPressedOutside,
				onActivated = onActivated
			})
		}
	)
end

local function renderPrivateServerLink(props)
	local createElement = React.createElement

	local createElement2 = React.createElement

	local v = {
		Text = React.createElement(View, { tag = "col fill gap-xsmall auto-y", LayoutOrder = 1 }, {
			Heading = React.createElement(Text, {
				Text = props.locales.privateServerLink,
				tag = "auto-xy text-heading-small content-emphasis",
				LayoutOrder = 1
			}),
			Description = React.createElement(Text, {
				Text = props.locales.anyoneWithThisLinkCanJoin,
				tag = "auto-xy text-body-small content-muted",
				LayoutOrder = 2
			})
		}),
		Generate = 0
	}
	local generate

	if props.link == nil then
		generate = React.createElement(Button, {
			testId = "--purchase-prompt-button-generate-link",
			text = props.locales.generate,
			variant = ButtonVariant.Standard,
			size = InputSize.Small,
			isLoading = props.isGeneratingLink,
			onActivated = props.onGenerateLink,
			LayoutOrder = 2
		})
	end

	v.Generate = generate
	local children = {
		Header = createElement2(View, {
			tag = "row align-y-center gap-medium size-full-0 auto-y",
			LayoutOrder = 1
		}, v),
		Field = 0
	}

	local createElement3 = React.createElement
	local v2 = {
		testId = "--purchase-prompt-textinput-link",
		label = "",
		text = props.linkText,
		placeholder = props.locales.generateLinkPlaceholder,
		onChanged = props.onLinkTextChanged,
		isDisabled = props.link == nil,
		focusBehavior = InputFocusBehavior.Highlight,
		iconTrailing = 0,
		width = 0,
		LayoutOrder = 2
	}
	local iconTrailing

	if props.link then
		iconTrailing = { name = 0, onActivated = 0 }
		local name

		if props.isLinkCopied then
			name = IconName.Check
		else
			name = IconName.TwoStackedSquares
		end

		iconTrailing.name = name
		iconTrailing.onActivated = props.onCopyLink
	end

	v2.iconTrailing = iconTrailing

	v2.width = UDim.new(1, 0)
	children.Field = createElement3(TextInput, v2)
	return createElement(View, { tag = "col gap-small size-full-0 auto-y", LayoutOrder = 4 }, children)
end

local function VIPServerConfigurationView(props)
	local v = useTokens()

	local createElement = React.createElement
	local root = Dialog.Root
	local v2 = {
		size = DialogSize.Medium,
		onClose = 0,
		disablePortal = true,
		testId = "VIPServerConfigurationView"
	}
	local onClose

	if not props.isSaving then
		onClose = props.onCancel
	end

	v2.onClose = onClose

	local children = {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = props.locales.title }),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content

	local createElement3 = React.createElement

	local v3 = {
		ServerName = React.createElement(TextInput, {
			testId = "--purchase-prompt-textinput-server-name",
			label = props.locales.serverName,
			text = props.serverName,
			onChanged = props.onServerNameChanged,
			width = UDim.new(1, 0),
			LayoutOrder = 1
		}),
		WhoCanJoin = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			Heading = React.createElement(Text, {
				Text = props.locales.whoCanJoin,
				tag = "auto-xy text-heading-small content-emphasis",
				LayoutOrder = 1
			}),
			Search = React.createElement(PeopleSearch, { viewProps = props, LayoutOrder = 2 }),
			AddedPlayers = renderAddedPlayerChips(props),
			InThisServer = React.createElement(Text, {
				Text = props.locales.inThisServer,
				tag = "auto-xy text-title-small content-default",
				LayoutOrder = 4
			}),
			PlayerList = React.createElement(ScrollView, {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v.Gap.Small)
				},
				scroll = {
					ScrollingDirection = Enum.ScrollingDirection.Y,
					AutomaticSize = Enum.AutomaticSize.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(0, 0)
				},
				LayoutOrder = 5
			}, renderPlayerList(props))
		}),
		FriendsAllowed = React.createElement(
			View,
			{ tag = "row align-y-center gap-medium size-full-0 auto-y", LayoutOrder = 3 },
			{
				Text = React.createElement(View, {
					tag = "col fill gap-xxsmall auto-y",
					LayoutOrder = 1
				}, {
					Label = React.createElement(Text, {
						Text = props.locales.friendsAllowed,
						tag = "auto-xy text-body-medium content-emphasis",
						LayoutOrder = 1
					}),
					Description = React.createElement(Text, {
						Text = props.locales.friendsAllowedDescription,
						tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-muted",
						LayoutOrder = 2
					})
				}),
				Toggle = React.createElement(Toggle, {
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
	local err

	if props.hasError then
		err = React.createElement(Text, {
			testId = "--purchase-prompt-text-error",
			Text = props.locales.somethingWentWrong,
			tag = "auto-xy text-body-medium content-system-alert",
			LayoutOrder = 5
		})
	end

	v3.Error = err
	children.Content = createElement2(content, { LayoutOrder = 2 }, {
		Body = createElement3(View, { tag = "col gap-large size-full-0 auto-y" }, v3)
	})

	children.Actions = React.createElement(Dialog.Actions, {
		LayoutOrder = 3,
		orientation = Orientation.Horizontal,
		actions = {
			{
				testId = "--purchase-prompt-button-continue",
				text = props.locales.continue,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onSave,
				isLoading = props.isSaving
			}
		}
	})
	return createElement(root, v2, children)
end

return VIPServerConfigurationView
