local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local LinkingProtocol = require(parent.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local ReactRoblox = require(parent.ReactRoblox)
local RoactNavigation = require(parent.RoactNavigation)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)
local RobloxAppLocales = require(parent.RobloxAppLocales)

local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
local LibraryThemeProvider = require(BuildExperience.Components.Library.LibraryThemeProvider)
local LibraryLeavingOverlay = require(BuildExperience.Components.Library.LibraryLeavingOverlay)
require(BuildExperience.Components.Library.LibraryDetail.LibraryDetailContainer)
local LibraryExperienceView = require(BuildExperience.Components.Library.LibraryExperienceView)
local LibraryNavigator = require(BuildExperience.Components.Library.LibraryNavigator)

local useLibraryWorldCutoutViewModel = require(BuildExperience.Components.Library.LibraryWorldCutout.useLibraryWorldCutoutViewModel)
local getAndroidBackSignal = require(BuildExperience.utils.getAndroidBackSignal)
local bindLibraryBackInput = require(BuildExperience.utils.bindLibraryBackInput)
local leaveExperience = require(BuildExperience.utils.leaveExperience)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
require(BuildExperience.Components.Library.LibraryCategories)
local createBuildLibraryStore = require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)
local useLibraryStrings = require(BuildExperience.Components.Library.useLibraryStrings)
local GetLibraryStore = require(BuildExperience.Stores.GetLibraryStore)
local GetPlayButtonStore = require(BuildExperience.Stores.GetPlayButtonStore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local createViewerWorldPicker = require(BuildExperience.createViewerWorldPicker)
local LocalizationProvider = Localization.LocalizationProvider
local localization = RobloxAppLocales.Localization
local LibraryTypes = require(BuildExperience.Components.Library.LibraryTypes)
require(BuildExperience.Chat.chatTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

local v = nil
local v2 = nil

local function requestModelFocus(instance, p) -- 3 equivalent calls inferred from this helper
	local boundingBox, v3 = instance:GetBoundingBox()
	p.requestFocus(boundingBox.Position, v3.Magnitude / 2, instance)
end

local function focusModel(model, p)
	if v ~= nil then
		v:Destroy()
	end

	local buildLibraryFocusHighlight = Instance.new("Highlight")
	buildLibraryFocusHighlight.Name = "BuildLibraryFocusHighlight"
	buildLibraryFocusHighlight.DepthMode = Enum.HighlightDepthMode.Occluded
	buildLibraryFocusHighlight.OutlineColor = Color3.fromRGB(0, 200, 255)
	buildLibraryFocusHighlight.FillColor = Color3.fromRGB(0, 170, 255)
	buildLibraryFocusHighlight.FillTransparency = 0.75
	buildLibraryFocusHighlight.Adornee = model
	buildLibraryFocusHighlight.Parent = CoreGui
	v = buildLibraryFocusHighlight
	requestModelFocus(model, p) -- inferred equivalent call
end

local function requestWorldFocus(items, p)
	local v3 = nil
	local v4 = nil

	for _, item in items do
		local boundingBox, v5 = item:GetBoundingBox()

		if v5 == Vector3.new(0, 0, 0) then
			continue
		end

		for i = -1, 1, 2 do
			for j = -1, 1, 2 do
				for k = -1, 1, 2 do
					local pointToWorldSpace = boundingBox:PointToWorldSpace(v5 * Vector3.new(i, j, k) / 2)

					if v3 == nil then
						v3 = pointToWorldSpace
					else
						v3 = v3:Min(pointToWorldSpace)
					end

					if v4 == nil then
						v4 = pointToWorldSpace
					else
						v4 = v4:Max(pointToWorldSpace)
					end
				end
			end
		end
	end

	if v3 ~= nil and v4 ~= nil then
		p.requestFocus((v3 + v4) / 2, (v4 - v3).Magnitude / 2)
	end
end

local function getWorkspace(dataModel) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return dataModel:GetService("Workspace")
	end)

	if success and typeof(result) == "Instance" and result:IsA("Workspace") then
		return result
	end

	return nil
end

local function ConnectedLibrary(props)
	local libraryStore = GetLibraryStore()
	local ref = React.useRef(os.clock())
	local ref2 = React.useRef(false)
	local v3 = React.useCallback(function()
		return { universeId = props.dataModel.GameId, placeId = props.dataModel.PlaceId }
	end, { props.dataModel })
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local v4 = useLibraryStrings()
	local v5 = libraryStore.useIsOpen()
	local v6 = SignalsReact.useSignalState(libraryStore.getChatComposerState)
	local onAddResource

	if v6 == nil then
		onAddResource = nil
	else
		onAddResource = v6.onAddResource
	end

	local onRemoveResourceByPath

	if v6 == nil then
		onRemoveResourceByPath = nil
	else
		onRemoveResourceByPath = v6.onRemoveResourceByPath
	end

	local resourceActions = React.useMemo(function()
		if onAddResource == nil or onRemoveResourceByPath == nil then
			return {
				onAddResource = function(p): boolean
					libraryStore.requestAddToChat(p)
					return true
				end,
				onRemoveResource = libraryStore.requestRemoveFromChat
			}
		end

		return {
			onAddResource = function(p)
				local current = ref3.current

				if current ~= nil and current ~= p.path then
					ref3.current = nil
					ref4.current = nil
					onRemoveResourceByPath(current)
				end

				return onAddResource(p)
			end,
			onRemoveResource = function(p)
				onRemoveResourceByPath(p.path)
			end
		}
	end, { onAddResource or false, onRemoveResourceByPath or false, libraryStore })

	local state, setState = React.useState({ routeName = "Browser" })
	local itemId

	if state.routeName == "Detail" then
		itemId = state.params.itemId
	else
		itemId = nil
	end

	local kind = itemId == nil and "Model" or state.params.itemKind
	local params

	if state.routeName == "Category" or state.routeName == "Search" and state.params.itemKind ~= nil then
		params = state.params
	else
		params = nil
	end

	local v7 = React.useMemo(function()
		return getWorkspace(props.dataModel) -- inferred equivalent call
	end, { props.dataModel })
	local v8 = SignalsReact.useSignalState(props.library.getItems)

	local v9 = React.useMemo(function()
		local models = {}

		if v7 == nil then
			return models
		end

		local Players = props.dataModel:GetService("Players")

		for _, v9 in v8 do
			local model = v9.model

			if not (model ~= nil and model:IsDescendantOf(v7) and Players:GetPlayerFromCharacter(model) == nil) then
				continue
			end

			table.insert(models, model)
		end

		return models
	end, { v7, v8, props.dataModel })
	local isAvailable = #v9 > 0
	local v10 = useLibraryWorldCutoutViewModel({
		isAvailable = isAvailable,
		isHome = state.routeName == "Browser",
		isOpen = v5,
		onViewportRectChanged = libraryStore.setWorldViewportRect
	})

	local function fn()
		local v11

		if itemId ~= nil then
			v11 = props.library.getItem(false, itemId)
		end

		local v12 = v3()
		local v13 = {
			phase = "viewed",
			surface = not v5 and "World" or state.routeName,
			kind = 0,
			scope = 0,
			hasDescription = 0,
			location = 0
		}
		local kind2

		if itemId == nil then
			kind2 = params == nil and "All" or params.itemKind
		else
			kind2 = kind
		end

		v13.kind = kind2

		v13.scope = (params == nil or params.folderId == nil) and "Root" or "Folder"
		local hasDescription

		if v11 ~= nil then
			hasDescription = tostring(v11.description ~= nil)
		end

		v13.hasDescription = hasDescription
		local location

		if v11 ~= nil then
			location = v11.rootName
		end

		v13.location = location
		sendBuildExperienceEvent("LIBRARY_IMPRESSION", v12, v13)
	end

	React.useEffect(fn, {
		props.library,
		v3,
		v5,
		state.routeName,
		itemId or false,
		kind,
		params ~= nil and (params.folderId or params.itemKind)
	})

	local ref5 = React.useRef(nil)
	local externalDispatchConnector = React.useCallback(function(current)
		ref5.current = current
		return function()
			ref5.current = nil
		end
	end, {})
	local onNavigationStateChange = React.useCallback(function(_, p)
		setState(p.routes[p.index])
	end, {})
	local state2, setState2 = React.useState("")
	local ref6 = React.useRef(nil)
	local v11 = React.useCallback(function(p: string)
		setState2(p)
		local current = ref5.current

		if current ~= nil then
			local UserGameSettings = UserSettings():GetService("UserGameSettings")
			local reducedMotion = UserGameSettings.ReducedMotion

			if p == "" or state.routeName == "Search" then
				if p == "" and state.routeName == "Search" then
					current(RoactNavigation.StackActions.pop({ immediate = reducedMotion }))
				end
			else
				current(RoactNavigation.Actions.navigate({
					routeName = "Search",
					key = "LibrarySearch",
					params = params or {},
					immediate = reducedMotion
				}))
			end
		end

		if ref6.current ~= nil then
			task.cancel(ref6.current)
		end

		ref6.current = task.delay(0.3, function()
			ref6.current = nil
			sendBuildExperienceEvent("LIBRARY_SEARCH", v3(), {
				surface = params == nil and "Browser" or "Category",
				kind = params == nil and "All" or params.itemKind,
				scope = (params == nil or params.folderId == nil) and "Root" or "Folder",
				hasQuery = tostring(p ~= "")
			})
		end)
	end, { v3, state, params or false })

	local function fn2()
		return function()
			if ref6.current ~= nil then
				task.cancel(ref6.current)
				ref6.current = nil
			end
		end
	end

	React.useEffect(fn2, {
		itemId or false,
		params ~= nil and params.itemKind,
		params ~= nil and (params.folderId or false)
	})

	local onSearchReset = React.useCallback(function()
		v11("")
	end, { v11 })
	local library = props.library
	local state3, setState3 = React.useState(false)
	local v12 = React.useCallback(function()
		local success, result = pcall(function(): nil
			library.refresh()
			return nil
		end)

		if not success then
			sendBuildExperienceEvent("LIBRARY_FETCH_FAILED", v3(), {
				surface = "Library",
				phase = ref2.current and "refresh" or "initial",
				reason = "refresh_failed"
			})

			error(result, 0)
		end
	end, { library, v3 })
	React.useEffect(function()
		sendBuildExperienceEvent("LIBRARY_IMPRESSION", v3(), {
			phase = "opened",
			surface = "Library"
		})
		local dataModel = props.dataModel
		local function ready()
			v12()
			setState3(true)

			if not ref2.current then
				ref2.current = true
				local v13 = { Model = 0, Image = 0, Sound = 0, Folder = 0 }

				for _, v14 in library.getItems(false) do
					local v15 = v14.className == "Folder" and "Folder" or v14.kind
					v13[v15] += 1
				end

				sendBuildExperienceEvent("LIBRARY_IMPRESSION", v3(), {
					phase = "ready",
					surface = "Library",
					durationMs = tostring((math.round((os.clock() - ref.current) * 1000))),
					modelCount = tostring(v13.Model),
					imageCount = tostring(v13.Image),
					soundCount = tostring(v13.Sound),
					folderEntryCount = tostring(v13.Folder)
				})
			end
		end
		local loadedConnection = dataModel.Loaded:Connect(ready)
		local Workspace = dataModel:GetService("Workspace")
		local persistentLoadedConnection = Workspace.PersistentLoaded:Connect(ready)

		if dataModel:IsLoaded() then
			ready()
		end

		return function()
			loadedConnection:Disconnect()
			persistentLoadedConnection:Disconnect()
		end
	end, { library, props.dataModel, v12, v3 })
	local v13 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if itemId == nil then
				return nil
			end

			return library.getItem(p, itemId)
		end)
	end, { library, itemId or false })
	local v14 = SignalsReact.useSignalState(v13)

	local onBack = React.useCallback(function()
		local current = ref5.current

		if state.routeName == "Browser" or current == nil then
			libraryStore.setIsOpen(false)

			return
		end

		if state.routeName == "Search" then
			setState2("")
		else
			v12()
		end

		libraryStore.setIsOpen(true)
		GetPlayButtonStore().setIsActive(false)
		local pop = RoactNavigation.StackActions.pop
		local immediate

		if state.routeName == "Search" then
			local UserGameSettings = UserSettings():GetService("UserGameSettings")
			immediate = UserGameSettings.ReducedMotion
		else
			immediate = false
		end

		current(pop({ immediate = immediate }))
	end, { state.routeName, libraryStore, v12 })

	local onOpenCategory = React.useCallback(function(p, categoryKey, title: string, folderId: string?)
		v12()

		if folderId ~= nil then
			setState2("")
		end

		local current = ref5.current

		if current ~= nil then
			sendBuildExperienceEvent("LIBRARY_CATEGORY_CLICK", v3(), {
				action = folderId == nil and "category" or "folder",
				kind = p,
				surface = state.routeName
			})

			current(RoactNavigation.Actions.navigate({
				routeName = "Category",
				key = folderId == nil and "LibraryCategory" or `LibraryFolder:{folderId}`,
				params = {
					itemKind = p,
					categoryKey = categoryKey,
					title = title,
					folderId = folderId
				}
			}))
		end
	end, { v12, v3, state.routeName })

	local onOpenItem = React.useCallback(function(itemId2: string, p)
		local current = ref5.current

		if current ~= nil then
			local item = library.getItem(false, itemId2)
			local v15 = v3()
			local v16 = {
				action = "detail",
				kind = p,
				surface = not libraryStore.getIsOpen(false) and "World" or state.routeName,
				location = 0
			}
			local location

			if item ~= nil then
				location = item.rootName
			end

			v16.location = location
			sendBuildExperienceEvent("LIBRARY_ASSET_CLICK", v15, v16)

			current(RoactNavigation.Actions.navigate({
				routeName = "Detail",
				key = "LibraryDetail",
				params = { itemId = itemId2, itemKind = p }
			}))
		end
	end, { v3, state.routeName, libraryStore, library })

	local ref7 = React.useRef(false)
	local ref8 = React.useRef(nil)
	React.useEffect(function()
		if ref7.current or v7 == nil then
			return
		end

		if not v5 or v10.phase ~= "Home" then
			ref7.current = true
			return
		end

		if not (state3 and v10.isMeasured) then
			return
		end

		if FFlagBuildExperienceLibrary then
			if isAvailable then
				ref7.current = true
				requestWorldFocus(v9, libraryStore)
			end
		else
			for _, v15 in v8 do
				local model = v15.model

				if v15.folderId == nil and v15.className ~= "Folder" and model ~= nil and model:IsDescendantOf(v7) then
					ref7.current = true
					ref8.current = model
					requestModelFocus(model, libraryStore) -- inferred equivalent call
					return
				end
			end
		end
	end, {
		v8,
		state3,
		v5,
		v10.phase,
		v10.isMeasured,
		v7,
		libraryStore,
		isAvailable,
		v9
	})

	local current2 = v5 and state.routeName == "Browser"
	local ref9 = React.useRef(current2)
	React.useEffect(function()
		if FFlagBuildExperienceLibrary then
			if current2 and not ref9.current and ref7.current and isAvailable then
				requestWorldFocus(v9, libraryStore)
			end

			ref9.current = current2
		else
			local current = ref8.current
			local focusRequest = libraryStore.getFocusRequest(false)

			if
				current2
				and not ref9.current
				and current ~= nil
				and v7 ~= nil
				and current:IsDescendantOf(v7)
				and (focusRequest == nil or focusRequest.model ~= current)
			then
				requestModelFocus(current, libraryStore) -- inferred equivalent call
			end

			ref9.current = current2
		end
	end, { current2, v7, libraryStore, isAvailable, v9 })

	local ref10 = React.useRef("Browser")
	ref10.current = not v5 and "World" or state.routeName
	local ref11 = React.useRef(false)
	local current3 = React.useCallback(function(reason: string)
		if ref11.current then
			return
		end

		ref11.current = true
		sendBuildExperienceEvent("LIBRARY_IMPRESSION", v3(), {
			phase = "closed",
			reason = reason,
			surface = ref10.current
		})
	end, { v3 })
	local ref12 = React.useRef(current3)
	ref12.current = current3
	React.useEffect(function()
		return function()
			ref12.current("other")
		end
	end, {})

	React.useEffect(function()
		local ReplicatedFirst = game:GetService("ReplicatedFirst")
		ReplicatedFirst:RemoveDefaultLoadingScreen()
		return function()
			props.onUnmount()

			if v ~= nil then
				v:Destroy()
				v = nil
			end
		end
	end, { props.onUnmount })

	local state4, setState4 = React.useState(false)
	local ref13 = React.useRef(false)

	local state5, setState5 = React.useState(false)
	React.useEffect(function()
		local renderSteppedConnection = RunService.RenderStepped:Once(function()
			setState5(true)
		end)
		return function()
			renderSteppedConnection:Disconnect()
		end
	end, {})
	React.useEffect(function()
		if current2 and v ~= nil then
			v:Destroy()
			v = nil
		end
	end, { current2 })

	local ref14 = React.useRef(0)
	React.useEffect(function()
		if v14 == nil or v14.model == nil then
			return
		end

		local flag = true
		local destroyingConnection = v14.model.Destroying:Connect(function()
			ref14.current += 1
			libraryStore.clearFocus()
			ref3.current = nil
			ref4.current = nil
			resourceActions.onRemoveResource(LibraryTypes.toChatResource(v14))

			if v ~= nil then
				v:Destroy()
				v = nil
			end

			task.defer(function()
				if flag then
					v12()
				end
			end)
		end)
		return function()
			flag = false
			destroyingConnection:Disconnect()
		end
	end, {
		v14 or false,
		libraryStore,
		resourceActions,
		v12
	})
	local v15 = SignalsReact.useSignalState(GetPlayButtonStore().getIsActive)
	local current4

	if v6 == nil then
		current4 = false
	else
		current4 = v6.isAssistantResponding == true
	end

	local ref15 = React.useRef(false)
	local ref16 = React.useRef(nil)
	local v16 = SignalsReact.useSignalState(libraryStore.getPromptFailure)
	local ref17 = React.useRef(v16 == nil and 0 or v16.token)
	React.useEffect(function()
		if v16 == nil or v16.token <= ref17.current then
			return
		end

		ref17.current = v16.token
		local current = ref16.current

		if current == nil then
			return
		end

		ref16.current = nil
		local clone = table.clone(current)
		clone.phase = "failed"

		if v16.errorCode ~= nil then
			clone.errorCode = tostring(v16.errorCode)
		end

		sendBuildExperienceEvent("LIBRARY_ASSET_CLICK", v3(), clone)
	end, { v16, v3 })
	React.useEffect(function()
		if ref15.current and not current4 then
			ref16.current = nil
		end

		if ref15.current and not current4 and state3 and v5 then
			v12()
		end

		ref15.current = current4
	end, { current4, state3, v5, v12 })
	local v17 = React.useCallback(function(p, flag: boolean)
		if p.model ~= nil and not p.model:IsDescendantOf(workspace) then
			return
		end

		if p.model ~= nil then
			focusModel(p.model, libraryStore)
		end

		libraryStore.setIsOpen(false)
		ref14.current += 1
		local current = ref14.current
		task.defer(function()
			if ref14.current ~= current or libraryStore.getIsOpen(false) then
				return
			end

			local chatResource = LibraryTypes.toChatResource(p)
			libraryStore.requestAddToChat(chatResource, ref3.current, flag)
			ref3.current = chatResource.path
			ref4.current = chatResource
			GetPlayButtonStore().setIsActive(true)
		end)
	end, { libraryStore })
	React.useEffect(function()
		return function()
			ref14.current += 1
		end
	end, {})

	local v18 = SignalsReact.useSignalState(libraryStore.getChipEvent)
	React.useEffect(function()
		local current = ref4.current

		if v18 == nil or current == nil or not table.find(v18.uris, LibraryTypes.toResourceUri(current.path)) then
			return
		end

		if v18.kind == "Removed" then
			ref3.current = nil
			ref4.current = nil

			if v ~= nil then
				v:Destroy()
				v = nil
			end
		elseif v18.kind == "Activated" then
			for _, v19 in library.getItems(false) do
				if not (v19.path == current.path and v19.model ~= nil and v19.model:IsDescendantOf(workspace)) then
					continue
				end

				focusModel(v19.model, libraryStore)
			end
		else
			libraryStore.requestAddToChat(current, nil, false)
		end
	end, { v18, libraryStore, library.getItems })
	React.useEffect(function()
		if v5 or not (state3 and isAvailable) then
			return nil
		end

		local Workspace = props.dataModel:GetService("Workspace")
		local currentCamera = Workspace.CurrentCamera

		if currentCamera == nil then
			return nil
		end

		local v19 = true
		local viewerWorldPicker = createViewerWorldPicker({
			camera = currentCamera,
			userInputService = props.dataModel:GetService("UserInputService"),
			world = Workspace,
			isBlocked = function()
				return not v19 or libraryStore.getIsOpen(false)
			end,
			onPick = function(p)
				local v20 = library.resolveWorldItem(p)

				if v20 == nil then
					v12()
					v20 = library.resolveWorldItem(p)
				end

				if v20 ~= nil then
					onOpenItem(v20.id, v20.kind)
					v17(v20, not GetPlayButtonStore().getIsActive(false))
				end
			end,
			onMiss = function()
				local current = ref4.current

				if current == nil then
					return
				end

				ref3.current = nil
				ref4.current = nil
				resourceActions.onRemoveResource(current)

				if v ~= nil then
					v:Destroy()
					v = nil
				end
			end
		})

		return function()
			v19 = false
			viewerWorldPicker()
		end
	end, {
		v5,
		state3,
		isAvailable,
		libraryStore,
		library,
		v12,
		v17,
		onOpenItem,
		resourceActions,
		props.dataModel
	})

	local function fn3()
		if state3 then
			v12()
		end

		if not libraryStore.getIsOpen(false) then
			sendBuildExperienceEvent(
				"LIBRARY_ASSET_CLICK",
				v3(),
				v10.exit() and {
					action = "back",
					kind = "All",
					surface = "World",
					source = "home_cutout"
				} or { action = "object", kind = kind, surface = "World" }
			)
		end

		ref14.current += 1
		GetPlayButtonStore().setIsActive(false)
		libraryStore.setIsOpen(true)
	end
	local onWorldViewportChanged = React.useCallback(function(p)
		local setWorldViewportRect = libraryStore.setWorldViewportRect
		local v19

		if p ~= nil then
			v19 = Rect.new(p.AbsolutePosition, p.AbsolutePosition + p.AbsoluteSize)
		end

		setWorldViewportRect(v19)
	end, { libraryStore })
	local function fn4(value: string?)
		if itemId ~= nil then
			local item = library.getItem(false, itemId)

			if item ~= nil then
				local isOpen = libraryStore.getIsOpen(false)
				v17(item, value ~= "prompt")
				local v19 = isOpen and not libraryStore.getIsOpen(false)

				if v19 or isOpen and item.model ~= nil and not item.model:IsDescendantOf(workspace) then
					sendBuildExperienceEvent("LIBRARY_ASSET_CLICK", v3(), {
						action = "world",
						outcome = not v19 and "unavailable" or nil,
						kind = item.kind,
						surface = "Detail",
						source = value or "segmented_control",
						location = item.rootName
					})
				end

				return
			end
		end

		libraryStore.setIsOpen(false)
	end
	local function onActivated()
		if state.routeName ~= "Browser" or not (libraryStore.getIsOpen(false) and v10.enter()) then
			return
		end

		sendBuildExperienceEvent("LIBRARY_ASSET_CLICK", v3(), {
			action = "world",
			kind = "All",
			surface = "Home",
			source = "home_cutout"
		})

		if FFlagBuildExperienceLibrary then
			requestWorldFocus(v9, libraryStore)
		end

		fn4()
	end
	local function returnToAppChat(p: string?, p2: string)
		if ref13.current then
			return
		end

		ref13.current = true
		setState4(true)
		current3(p2)
		local v19 = p or props.sessionId
		local v20 = `roblox://navigation/build?universeid={props.dataModel.GameId}`

		if v19 ~= nil then
			v20 ..= `&sessionid={HttpService:UrlEncode(v19)}`
		end

		if default:isInternalDlicEnabled() then
			local internalDlic = default:createInternalDlic(v20, DeepLinkSource.LuaInternal)
			task.spawn(leaveExperience, function()
				default:detectDeeplinkIntent(internalDlic)
			end)
		else
			task.spawn(leaveExperience, function()
				default:detectURL(v20)
			end)
		end
	end
	local function onNavigateBack()
		if ref13.current then
			return
		end

		if not v5 then
			fn3()
		elseif state.routeName == "Browser" then
			returnToAppChat(nil, "back_button")
		else
			onBack()
		end
	end
	local ref18 = React.useRef(onNavigateBack)
	ref18.current = onNavigateBack
	local ref19 = React.useRef(nil)
	React.useEffect(function()
		local function navigateBack()
			ref18.current()
		end
		local connection = getAndroidBackSignal():Connect(navigateBack)
		local current = bindLibraryBackInput(navigateBack)
		ref19.current = current
		return function()
			connection:Disconnect()
			current.unbind()
			ref19.current = nil
		end
	end, {})
	React.useEffect(function()
		if ref19.current ~= nil then
			ref19.current.setChatOpen(v15)
		end
	end, { v15 })
	local clone

	if v6 ~= nil then
		clone = table.clone(v6)
	end

	if clone ~= nil and v6 ~= nil then
		local onSend = v6.onSend
		function clone.onSend()
			local current = { action = "prompt", kind = kind, surface = "Detail", location = 0 }
			local location

			if v14 ~= nil then
				location = v14.rootName
			end

			current.location = location

			local function onPromptAccepted() -- 1 equivalent call inferred from this helper
				local clone2 = table.clone(current)
				clone2.phase = "received"
				sendBuildExperienceEvent("LIBRARY_ASSET_CLICK", v3(), clone2)
			end

			local v19

			if kind == "Image" or kind == "Sound" then
				v19 = onSend(function(p: string?)
					onPromptAccepted() -- inferred equivalent call
					returnToAppChat(p, "prompt_return")
				end)
			else
				v19 = onSend(onPromptAccepted)
			end

			if v19 then
				ref16.current = current
			end

			if v19 and kind == "Model" then
				fn4("prompt")
			end

			local clone2 = table.clone(current)
			clone2.phase = "submit"
			clone2.outcome = v19 and "accepted" or "rejected"
			sendBuildExperienceEvent("LIBRARY_ASSET_CLICK", v3(), clone2)
			return v19
		end
	end

	local element = React.createElement(LibraryNavigator, {
		externalDispatchConnector = externalDispatchConnector,
		onNavigationStateChange = onNavigationStateChange,
		screenProps = {
			library = library,
			isReady = state3,
			isOpen = v5,
			activeRouteKey = state.key,
			query = state2,
			onBack = onBack,
			onOpenItem = onOpenItem,
			onOpenCategory = onOpenCategory,
			chatActions = clone,
			resourceActions = resourceActions,
			unavailableText = v4.modelUnavailable,
			worldCutout = (isAvailable or FFlagBuildExperienceLibrary and not state3) and {
				title = v4.world,
				onActivated = onActivated,
				onRectChanged = v10.onCellRectChanged
			} or nil
		}
	})
	local assetLabel

	if itemId == nil then
		assetLabel = v4.title
	elseif kind == "Model" then
		assetLabel = v4.object
	else
		assetLabel = if kind == "Image" then v4.image else v4.sound
	end

	local createElement = React.createElement
	local focusRoot = FocusNavigationUtils.FocusRoot
	local v19 = {
		surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = v5,
		isFocusable = v5,
		isIsolated = true
	}

	local createElement2 = React.createElement
	local v20 = {
		isOpen = v5,
		showModeControl = nil,
		isWorldAvailable = 0,
		title = 0,
		onBack = 0,
		query = 0,
		searchPlaceholder = 0,
		onQueryChanged = 0,
		onSearchReset = 0,
		assetLabel = 0,
		worldLabel = 0,
		onShowLibrary = 0,
		onShowWorld = 0,
		onWorldViewportChanged = 0,
		worldCutout = 0,
		onLeave = 0
	}
	local showModeControl

	if isAvailable then
		if itemId == nil then
			showModeControl = false
		else
			showModeControl = kind == "Model"
		end
	else
		showModeControl = isAvailable
	end

	v20.showModeControl = showModeControl
	local isWorldAvailable

	if not (v14 == nil or v14.model == nil) then
		isWorldAvailable = v14.model:IsDescendantOf(workspace)
	end

	v20.isWorldAvailable = isWorldAvailable
	local title

	if itemId == nil then
		if v10.phase == "Expanding" or v10.phase == "World" then
			title = v4.world
		else
			title = if params == nil then v4.title else params.title
		end
	else
		title = if v14 == nil then assetLabel else v14.displayName
	end

	v20.title = title
	local onBack2

	if itemId == nil and params == nil and state.routeName ~= "Search" then
		if not v5 then
			onBack2 = fn3
		end
	else
		onBack2 = onBack
	end

	v20.onBack = onBack2

	if itemId ~= nil then
		state2 = nil
	end

	v20.query = state2
	v20.searchPlaceholder = v4.searchPlaceholder
	local onQueryChanged

	if itemId == nil then
		onQueryChanged = v11
	end

	v20.onQueryChanged = onQueryChanged

	if itemId ~= nil then
		onSearchReset = nil
	end

	v20.onSearchReset = onSearchReset
	v20.assetLabel = assetLabel
	v20.worldLabel = v4.world
	v20.onShowLibrary = fn3
	v20.onShowWorld = fn4
	v20.onWorldViewportChanged = onWorldViewportChanged
	v20.worldCutout = v10.view
	function v20.onLeave()
		returnToAppChat(nil, "close_button")
	end

	local v21 = {
		Experience = createElement2(LibraryExperienceView, v20, element),
		Leaving = 0,
		FirstFrameCover = 0
	}
	local leaving

	if state4 then
		leaving = React.createElement(LibraryLeavingOverlay, { ZIndex = 2 })
	end

	v21.Leaving = leaving
	local firstFrameCover

	if not state5 then
		firstFrameCover = React.createElement(Foundation.View, {
			ZIndex = 3,
			tag = "size-full bg-surface-0",
			testId = "Library.FirstFrameCover"
		})
	end

	v21.FirstFrameCover = firstFrameCover
	return createElement(focusRoot, v19, v21)
end

local function mountLibrary(p, sessionId: string?)
	if v2 ~= nil then
		return v2
	end

	GetLibraryStore().setIsOpen(true)

	local buildExperienceLibrary = Instance.new("ScreenGui")
	buildExperienceLibrary.Name = "BuildExperienceLibrary"
	buildExperienceLibrary.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	buildExperienceLibrary.ClipToDeviceSafeArea = false
	buildExperienceLibrary.ResetOnSpawn = false
	buildExperienceLibrary.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	buildExperienceLibrary.DisplayOrder = 10
	buildExperienceLibrary.Parent = CoreGui

	local buildLibraryStore = createBuildLibraryStore(p or game)
	local root = ReactRoblox.createRoot(buildExperienceLibrary)
	v2 = root
	local localization2 = localization.new(LocalizationService.RobloxLocaleId)

	local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

	ReactRoblox.flushSync(function()
		root:render(React.createElement(LocalizationProvider, { localization = localization2 }, {
			FoundationProvider = React.createElement(LibraryThemeProvider, { displayOrder = 10 }, {
				CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
				Library = React.createElement(
					ReactFocusNavigation.FocusNavigationContext.Provider,
					{ value = focusNavigationService },
					{
						Registry = React.createElement(
							FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider,
							nil,
							{
								Content = React.createElement(ConnectedLibrary, {
									dataModel = p or game,
									library = buildLibraryStore,
									sessionId = sessionId,
									onUnmount = function()
										focusNavigationService:teardown()
										v2 = nil
										buildExperienceLibrary:Destroy()
									end
								})
							}
						)
					}
				)
			})
		}))
	end)

	return root
end

return mountLibrary
