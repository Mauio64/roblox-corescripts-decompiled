local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local ContextActionService = game:GetService("ContextActionService")

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default

require(script.Parent.VIPServerConfigurationView)
require(PurchasePrompt.types)

local function trim(value: string) -- 2 equivalent calls inferred from this helper
	return (value:match("^%s*(.-)%s*$"))
end

local function getOtherPlayers(players)
	local otherPlayers = {}

	for _, v in players:GetPlayers() do
		if v ~= players.LocalPlayer then
			table.insert(otherPlayers, v)
		end
	end

	return otherPlayers
end

local function useVIPServerConfigurationViewModel(data)
	local locales = useLocalization({
		title = "Feature.PrivateServers.Heading.ConfigurePrivateServer",
		serverName = "Feature.PrivateServers.Label.ServerName",
		whoCanJoin = "Feature.PrivateServers.Label.WhoCanJoin",
		searchPeople = "Feature.PrivateServers.Label.SearchPeople",
		inThisServer = "Feature.PrivateServers.Label.InThisServer",
		noOne = "Feature.AccountSettings.Label.DropDown.NoOne",
		add = "CommonUI.Features.Label.Add",
		friendsAllowed = "Feature.PrivateServers.Label.FriendsAllowed",
		friendsAllowedDescription = "Feature.PrivateServers.Description.FriendsAllowed",
		privateServerLink = "Feature.PrivateServers.Label.PrivateServerLink",
		anyoneWithThisLinkCanJoin = "Feature.PrivateServers.Label.AnyoneWithThisLinkCanJoin",
		generate = "Feature.PrivateServers.Action.Generate",
		generateLinkPlaceholder = "Feature.PrivateServers.Label.PrivateServerGenerateLinkPlaceholder",
		somethingWentWrong = "CommonUI.Messages.Response.SomethingWentWrong",
		continue = "CommonUI.Controls.Action.Continue"
	})

	local serverName, onServerNameChanged = React.useBinding(data.defaultServerName)
	local state, setState = React.useState("")

	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	local state4, setState4 = React.useState({})
	local state5, setState5 = React.useState({})
	local state6, setState6 = React.useState(nil)

	local linkText, v = React.useBinding("")
	local state7, setState7 = React.useState(false)
	local state8, setState8 = React.useState(false)
	local ref = React.useRef(nil)
	local state9, setState9 = React.useState(false)
	local state10, setState10 = React.useState(false)
	local state11, setState11 = React.useState(function()
		return getOtherPlayers(data.players)
	end)

	local ref2 = React.useRef(false)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(true)

	React.useEffect(function()
		data.logEvent({
			event_type = "show",
			component = "private_server_config",
			subscription_status = "active",
			server_active = true,
			friends_allowed = false,
			price = data.price,
			offer_type = data.offerType,
			num_server_members = 0
		})
	end, {})

	React.useEffect(function()
		ref4.current = true
		return function()
			ref4.current = false

			if ref.current then
				task.cancel(ref.current)
			end
		end
	end, {})

	React.useEffect(function()
		local playerAddedConnection = data.players.PlayerAdded:Connect(function(player)
			setState11(function(list)
				if table.find(list, player) then
					return list
				end

				local clone = table.clone(list)
				table.insert(clone, player)
				return clone
			end)
		end)

		local playerRemovingConnection = data.players.PlayerRemoving:Connect(function(player)
			setState11(function(items)
				local result = {}

				for _, item in items do
					if item ~= player then
						table.insert(result, item)
					end
				end

				return result
			end)
		end)
		return function()
			playerAddedConnection:Disconnect()
			playerRemovingConnection:Disconnect()
		end
	end, { data.players })
	local v2 = trim(state) -- inferred equivalent call
	local v3 = (utf8.len(v2) or 0) >= 3

	React.useEffect(function()
		if not v3 then
			setState5({})
			return nil
		end

		local flag = true
		local thread = task.delay(0.3, function()
			data.searchUsers(v2):andThen(function(p)
				if flag then
					setState5(p)
				end
			end):catch(function()
				if flag then
					setState5({})
				end
			end)
		end)
		return function()
			flag = false
			task.cancel(thread)
		end
	end, { v2, v3, data.searchUsers })

	local v4 = React.useCallback(function(p: number, p2: string?)
		setState4(function(p3)
			local clone = table.clone(p3)

			if p2 then
				clone[p] = p2
				return clone
			end

			clone[p] = nil

			return clone
		end)
	end, {})

	local players = React.useMemo(function()
		local result = {}

		for _, v5 in state11 do
			local userId = v5.UserId
			local displayName = v5.DisplayName
			local isAdded = state4[userId] ~= nil
			table.insert(result, {
				userId = userId,
				displayName = displayName,
				isAdded = isAdded,
				onToggleAdded = function()
					local v6

					if not isAdded then
						v6 = displayName
					end

					v4(userId, v6)
				end
			})
		end

		return result
	end, { state11, state4, v4 })

	local userId = data.players.LocalPlayer.UserId
	local searchResults = React.useMemo(function()
		local result = {}

		if not v3 then
			return result
		end

		for _, v5 in state5 do
			if v5.userId ~= userId and state4[v5.userId] == nil then
				table.insert(result, {
					userId = v5.userId,
					displayName = v5.displayName,
					onSelected = function()
						v4(v5.userId, v5.displayName)
						setState("")
					end
				})
			end
		end

		return result
	end, { v3, state5, state4, userId, v4 })

	local addedPlayers = React.useMemo(function()
		local result = {}

		for k, displayName in state4 do
			table.insert(result, {
				userId = k,
				displayName = displayName,
				onRemove = function()
					v4(k, nil)
				end
			})
		end

		table.sort(result, function(a, b): boolean
			return a.displayName < b.displayName
		end)

		return result
	end, { state4, v4 })

	local onGenerateLink = React.useCallback(function()
		if ref2.current then
			return
		end

		ref2.current = true
		setState7(true)
		setState10(false)
		data.logEvent({
			event_type = "click",
			component = "private_server_config",
			subcomponent = "generate_private_server_link_btn",
			action = "generate"
		})

		data.generateLink():andThen(function(p: string)
			if ref4.current then
				setState6(p)
				v(p)
				setState7(false)
			end
		end):catch(function()
			ref2.current = false

			if ref4.current then
				setState7(false)
				setState10(true)
			end
		end)
	end, { data.generateLink, data.logEvent, v })

	local onLinkTextChanged = React.useCallback(function(p: string)
		if state6 ~= nil and p ~= state6 then
			v(state6)
		end
	end, { state6, v })

	local onCopyLink = React.useCallback(function()
		if state6 == nil then
			return
		end

		data.logEvent({
			event_type = "click",
			component = "private_server_config",
			subcomponent = "copy_private_server_link_btn"
		})
		default:setClipboardText({ context = "PurchasePromptVIPServerLink", text = state6 })

		setState8(true)

		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(2, function()
			ref.current = nil
			setState8(false)
		end)
	end, { state6, data.logEvent })

	local onFriendsAllowedChanged = React.useCallback(function(flag: boolean)
		data.logEvent({
			event_type = "click",
			component = "private_server_config",
			subcomponent = "friends_allowed_toggle",
			target_state = flag and "enabled" or "disabled"
		})

		setState3(flag)
	end, { data.logEvent })

	local onSave = React.useCallback(function()
		if ref3.current then
			return
		end

		ref3.current = true
		setState9(true)
		setState10(false)

		local name = trim(serverName:getValue()) -- inferred equivalent call
		local usersToAdd = {}

		for k in state4 do
			table.insert(usersToAdd, k)
		end

		data.logEvent({
			event_type = "click",
			component = "private_server_config",
			subcomponent = "cta_btn",
			added_count = #usersToAdd,
			friends_allowed = state3
		})

		local save = data.save

		if name == "" or name == data.defaultServerName then
			name = nil
		end

		save({ name = name, friendsAllowed = state3, usersToAdd = usersToAdd }):andThen(function()
			if ref4.current then
				data.onSaved()
			end
		end):catch(function()
			ref3.current = false

			if ref4.current then
				setState9(false)
				setState10(true)
			end
		end)
	end, {
		serverName,
		state4,
		state3,
		data.save,
		data.onSaved,
		data.defaultServerName,
		data.logEvent
	})
	local isSearchMenuOpen

	if #searchResults > 0 then
		isSearchMenuOpen = not state2
	else
		isSearchMenuOpen = false
	end

	local onSearchTextChanged = React.useCallback(function(p: string)
		setState2(false)
		setState(p)
	end, {})

	local onSearchMenuDismissed = React.useCallback(function()
		setState2(true)
	end, {})

	local onDismiss = React.useCallback(function()
		data.logEvent({
			event_type = "click",
			component = "private_server_config",
			subcomponent = "cancel_btn"
		})
		data.onClose()
	end, { data.onClose, data.logEvent })

	local v5 = React.useCallback(function()
		if isSearchMenuOpen then
			setState2(true)
		elseif not ref3.current then
			onDismiss()
		end
	end, { isSearchMenuOpen, onDismiss })

	local focusRootRef = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		isFocusable = not isSearchMenuOpen
	})

	local ref5 = React.useRef(v5)
	ref5.current = v5

	React.useEffect(function()
		ContextActionService:BindCoreAction("VIPServerConfigurationCancelButtonBind", function(_, p)
			if p == Enum.UserInputState.Begin then
				ref5.current()
			end
		end, false, Enum.KeyCode.ButtonB)
		return function()
			ContextActionService:UnbindCoreAction("VIPServerConfigurationCancelButtonBind")
		end
	end, {})

	return {
		locales = locales,
		serverName = serverName,
		onServerNameChanged = onServerNameChanged,
		searchText = state,
		onSearchTextChanged = onSearchTextChanged,
		isSearchMenuOpen = isSearchMenuOpen,
		onSearchMenuDismissed = onSearchMenuDismissed,
		searchResults = searchResults,
		players = players,
		addedPlayers = addedPlayers,
		friendsAllowed = state3,
		onFriendsAllowedChanged = onFriendsAllowedChanged,
		link = state6,
		linkText = linkText,
		onLinkTextChanged = onLinkTextChanged,
		isGeneratingLink = state7,
		onGenerateLink = onGenerateLink,
		onCopyLink = onCopyLink,
		isLinkCopied = state8,
		hasError = state10,
		isSaving = state9,
		onSave = onSave,
		onCancel = v5,
		onDismiss = onDismiss,
		focusRootRef = focusRootRef
	}
end

return useVIPServerConfigurationViewModel
