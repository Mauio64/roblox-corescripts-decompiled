local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local AppComposition = require(parent.AppComposition)
local Promise = require(parent.Promise)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local useCompositionLayout = AppComposition.useCompositionLayout

local ScrollView = Foundation.ScrollView
local View = Foundation.View

local SignalsReact = require(parent.SignalsReact)

local DataHydration = require(parent.DataHydration)
local getGameMediaStore = DataHydration.Game.getGameMediaStore
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)

local createGalleryCaptureSource = require(parent.Moments.createGalleryCaptureSource)

local useTokens = Foundation.Hooks.useTokens
local getGameMediaForUniverse = require(BuildExperience.utils.getGameMediaForUniverse)
local useMediaUpdater = require(BuildExperience.utils.useMediaUpdater)

local uploadCaptureAsync = require(BuildExperience.utils.uploadCaptureAsync)
local getThumbnailUrlAsync = require(BuildExperience.utils.getThumbnailUrlAsync)
local createImageAssetAsync = require(BuildExperience.utils.createImageAssetAsync)

local CaptureSelectionView = require(script.Parent.CaptureSelectionView)
local FilmstripSlot = require(script.Parent.FilmstripSlot)
local MediaPreview = require(script.Parent.MediaPreview)
require(script.Parent.types)

local FFlagMediaSelectorErrorLogging = require(BuildExperience.Flags.FFlagMediaSelectorErrorLogging)

local formatError = require(BuildExperience.utils.formatError)
local Snackbar = Foundation.Snackbar

local function IconThumbnailsEditor(p)
	local v = useCompositionLayout()
	local v2 = useLocalization({
		captureLibrary = LocalizationStrings.MEDIA_SELECTION_CAPTURE_LIBRARY,
		delete = LocalizationStrings.MEDIA_SELECTION_DELETE
	})
	local v3

	if FFlagMediaSelectorErrorLogging then
		v3 = useLocalization({ mediaError = "Feature.Moments.Label.Error" })
	else
		v3 = nil
	end

	local captureLibrary = v2.captureLibrary
	local delete = v2.delete
	local gameMediaForUniverse = getGameMediaForUniverse(p.universeId)
	local v4 = React.useMemo(function()
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(p.universeId)
	end, { p.universeId })
	local v5 = SignalsReact.useSignalState(v4.data)
	local rootPlaceId

	if v5 then
		rootPlaceId = tostring(v5.rootPlaceId)
	else
		rootPlaceId = nil
	end

	local v6 = useTokens()
	local state, setState = React.useState(gameMediaForUniverse.icon)
	local state2, setState2 = React.useState(gameMediaForUniverse.thumbnails)
	local state3, setState3 = React.useState({ kind = "icon" })
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(nil)
	local state6, setState6 = React.useState("editor")
	local state7, setState7 = React.useState(nil)
	local state8, setState8 = React.useState({})
	local state9, setState9 = React.useState("")
	local ref = React.useRef(0)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(#gameMediaForUniverse.thumbnails + 1)

	local ref4 = React.useRef(nil)

	if ref4.current == nil then
		ref4.current = createGalleryCaptureSource(nil, nil, { Enum.CaptureType.Screenshot })
	end

	local ref5 = React.useRef(state2)
	ref5.current = state2
	local useRef = React.useRef(state)
	useRef.current = state

	local v7 = useMediaUpdater()

	React.useEffect(function()
		if ref.current ~= 0 then
			return
		end

		setState2(gameMediaForUniverse.thumbnails)
	end, { gameMediaForUniverse.thumbnails })

	React.useEffect(function()
		if ref.current == 0 then
			setState(gameMediaForUniverse.icon)
		end
	end, { gameMediaForUniverse.icon })

	local v8 = React.useMemo(function()
		local result = {}

		for _, v8 in state2 do
			table.insert(result, v8)
		end

		return result
	end, { state2 })
	local v9 = rootPlaceId ~= nil
	local v10 = #v8 < 10 and v9
	local id

	if v8[1] then
		id = v8[1].id
	else
		id = nil
	end

	local v11 = React.useCallback(function(p2: string, flag: boolean)
		setState8(function(p3)
			local clone = table.clone(p3)
			clone[p2] = flag and true or nil
			return clone
		end)
	end, {})

	local v12 = React.useCallback(function()
		ref.current += 1
	end, {})

	local v13 = React.useCallback(function()
		ref.current = math.max(0, ref.current - 1)
	end, {})

	local onClose = React.useCallback(function()
		setState9("")
	end, {})

	local v14 = React.useCallback(function(p2: string)
		local items = {}

		if v9 then
			table.insert(items, {
				id = "capture_library",
				text = captureLibrary,
				icon = "icons/common/image"
			})
		end

		if p2 ~= "icon" and p2 ~= id and p2 ~= "empty" then
			table.insert(items, { id = "delete", text = delete, icon = "icons/common/trash" })
		end

		return {
			{ items = items }
		}
	end, { v9, captureLibrary, delete, id })

	local v15 = React.useCallback(function(p2: string)
		if state8[p2] or ref2.current and p2 ~= "icon" and p2 ~= "empty" then
			return
		end

		setState5(p2)
		setState4(true)
	end, { state8 })

	local onMenuActivated = React.useCallback(function(p2: string)
		setState4(false)

		if ref2.current and state5 ~= "icon" and state5 ~= "empty" then
			return
		end

		if p2 == "capture_library" and v9 then
			setState7(state5)
			setState6("captureSelection")
		elseif p2 == "delete" then
			local v16 = state5

			if v16 == nil or rootPlaceId == nil or state8[v16] then
				return
			end

			local v17 = nil
			local v18 = nil

			for k, v19 in state2 do
				if v19.id == v16 then
					v18 = v19
					v17 = k
					break
				end
			end

			if v17 == nil or v18 == nil or not v18.assetResourceName then
				return
			end

			local assetResourceName = v18.assetResourceName
			ref2.current = true
			v12()
			v11(v16, true)
			setState2(function(items)
				local result = {}

				for _, item in items do
					if item.id ~= v16 then
						table.insert(result, item)
					end
				end

				return result
			end)

			if state3.kind == "thumbnail" and state3.id == v16 then
				setState3({ kind = "icon" })
			end

			v7.removePreview(rootPlaceId, assetResourceName):andThen(function()
				getGameMediaStore().fetchGameMedia((tostring(p.universeId)))
			end):catch(function(p3)
				if FFlagMediaSelectorErrorLogging then
					warn(`[BuildExperience] MediaSelector delete failed: {formatError(p3)}`)
					setState9(v3.mediaError)
				end

				setState2(function(items)
					for _, item in items do
						if item.id == v16 then
							return items
						end
					end

					local clone = table.clone(items)
					table.insert(clone, math.min(v17, #clone + 1), v18)
					return clone
				end)
			end):finally(function()
				ref2.current = false
				v11(v16, false)
				v13()
			end)
		end
	end, {
		state5,
		state3,
		state2,
		v7,
		rootPlaceId,
		v9,
		state8,
		v12,
		v13,
		v11,
		v3,
		p.universeId
	})

	local onMenuClose = React.useCallback(function()
		setState4(false)
	end, {})

	local onSelect = React.useCallback(function()
		setState3({ kind = "icon" })
	end, {})

	local v16 = React.useCallback(function(id2: string)
		setState3({ kind = "thumbnail", id = id2 })
	end, {})

	local onEditPressed = React.useCallback(function()
		v15("icon")
	end, { v15 })

	local v17 = React.useCallback(function()
		v15("empty")
	end, { v15 })

	local v18 = React.useCallback(function(p2)
		v15(p2)
	end, { v15 })

	local onCaptureConfirmed = React.useCallback(function(p2)
		local v19 = state7

		if v19 == nil or rootPlaceId == nil or state8[v19] then
			return
		end

		setState6("editor")
		setState7(nil)

		local v20 = nil
		local v21 = nil

		if v19 ~= "icon" and v19 ~= "empty" then
			for k, v22 in ref5.current do
				if v22.id == v19 then
					v21 = v22
					v20 = k
					break
				end
			end

			if v20 == nil or v21 == nil or not v21.assetResourceName then
				return
			end
		end

		local id2

		if v19 == "empty" then
			id2 = `thumbnail_pending_{ref3.current}`
			ref3.current += 1
		else
			id2 = v19
		end

		v12()
		v11(id2, true)

		if v19 == "icon" then
			setState3({ kind = "icon" })
		elseif v19 == "empty" then
			setState2(function(p3)
				local clone = table.clone(p3)
				table.insert(clone, { id = id2, mediaType = "image", assetSource = nil })

				return clone
			end)

			setState3({ kind = "thumbnail", id = id2 })
		else
			setState2(function(p3)
				local clone = table.clone(p3)

				for k, v22 in clone do
					if v22.id == v19 then
						clone[k] = { id = v22.id, mediaType = "image", assetSource = nil }

						return clone
					end
				end

				return clone
			end)
		end

		local v22 = uploadCaptureAsync(p2):andThen(function(p3)
			return getThumbnailUrlAsync(p3.assetId)
		end):andThen(function(p3)
			if typeof(p3) == "table" and p3.status == "in_review" then
				return Promise.reject({
					code = "IN_REVIEW",
					message = "Capture is under moderation review"
				})
			end

			local imageUrl = p3.imageUrl

			local v22 = v5 and {
				creatorType = v5.creatorType,
				creatorTargetId = v5.creatorTargetId
			} or nil

			return createImageAssetAsync(imageUrl, nil, v19 == "icon", v22):andThen(function(p4)
				return { imageAssetId = tostring(p4.assetId), displayUrl = imageUrl }
			end)
		end)

		local v23 = v22:andThen(function(p3)
			return p3.imageAssetId
		end)
		local v24

		if v19 == "icon" then
			v24 = v7.setIcon(rootPlaceId, v23)
		elseif v19 == "empty" then
			v24 = v7.addPreview(rootPlaceId, v23)
		else
			v24 = v7.replacePreview(rootPlaceId, v23, v21.assetResourceName)
		end

		v24:andThen(function()
			return v22
		end):andThen(function(p3)
			if v19 == "icon" then
				setState(p3.displayUrl)
			else
				local imageAssetId = p3.imageAssetId
				setState2(function(p4)
					local clone = table.clone(p4)

					for k, v25 in clone do
						if v25.id == id2 then
							clone[k] = {
								id = imageAssetId,
								mediaType = "image",
								assetSource = p3.displayUrl,
								assetResourceName = `assets/{p3.imageAssetId}`
							}

							return clone
						end
					end

					return clone
				end)

				setState3(function(p4)
					if p4.kind == "thumbnail" and p4.id == id2 then
						return { kind = "thumbnail", id = imageAssetId }
					end

					return p4
				end)
			end

			getGameMediaStore().fetchGameMedia((tostring(p.universeId)))
		end):catch(function(p3)
			if FFlagMediaSelectorErrorLogging then
				warn(`[BuildExperience] MediaSelector upload failed: {formatError(p3)}`)
				setState9(v3.mediaError)
			end

			if v19 == "icon" then
				return
			end

			if v19 == "empty" then
				setState2(function(items)
					local result = {}

					for _, item in items do
						if item.id ~= id2 then
							table.insert(result, item)
						end
					end

					return result
				end)

				setState3(function(p4)
					if p4.kind == "thumbnail" and p4.id == id2 then
						return { kind = "icon" }
					end

					return p4
				end)
			else
				local v25 = v21
				setState2(function(p4)
					local clone = table.clone(p4)

					for k, v26 in clone do
						if v26.id == id2 then
							clone[k] = v25
							return clone
						end
					end

					return clone
				end)
			end
		end):finally(function()
			v11(id2, false)
			v13()
		end)
	end, {
		state7,
		v7,
		rootPlaceId,
		v5,
		state8,
		v12,
		v13,
		v11,
		v3,
		p.universeId
	})

	local v19 = React.useCallback(function()
		setState6("editor")
		setState7(nil)
	end, {})

	React.useEffect(function()
		local backHandlerRef = p.backHandlerRef

		if backHandlerRef then
			local current

			if state6 == "captureSelection" then
				current = v19
			end

			backHandlerRef.current = current
		end

		return function()
			if backHandlerRef then
				backHandlerRef.current = nil
			end
		end
	end, { state6, v19, p.backHandlerRef })

	local menuItems = React.useMemo(function()
		if state5 then
			return v14(state5)
		end

		return {
			{ items = {} }
		}
	end, { state5, v14 })

	if state6 == "captureSelection" then
		return (React.createElement(CaptureSelectionView, {
			captureSource = ref4.current,
			onCaptureConfirmed = onCaptureConfirmed
		}))
	end

	local mediaType = nil
	local assetSource = nil
	local isIcon = false
	local isLoading = false

	if state3.kind == "icon" then
		isLoading = state8.icon or false
		assetSource = state
		mediaType = "image"
		isIcon = true
	elseif state3.kind == "thumbnail" then
		for _, v20 in v8 do
			if v20.id == state3.id then
				mediaType = v20.mediaType
				assetSource = v20.assetSource
				isLoading = state8[v20.id] or false
				break
			end
		end
	end

	local children = {}
	local isMenuOpen = state4 and state5 == "icon"
	local createElement = React.createElement
	local v20 = {
		aspectRatio = "square",
		mediaType = "image",
		assetSource = state,
		isFilled = true,
		isSelected = state3.kind == "icon",
		isLoading = state8.icon or false,
		isMenuOpen = isMenuOpen,
		menuItems = 0,
		onMenuActivated = 0,
		onMenuClose = 0,
		onSelect = 0,
		onEditPressed = 0,
		LayoutOrder = 1
	}
	local menuItems2

	if isMenuOpen then
		menuItems2 = menuItems
	end

	v20.menuItems = menuItems2
	v20.onMenuActivated = onMenuActivated
	v20.onMenuClose = onMenuClose
	v20.onSelect = onSelect

	if not v9 then
		onEditPressed = nil
	end

	v20.onEditPressed = onEditPressed
	children.IconSlot = createElement(FilmstripSlot, v20)

	for k, v21 in v8 do
		local id2 = v21.id
		local isSelected

		if state3.kind == "thumbnail" then
			isSelected = state3.id == id2
		else
			isSelected = false
		end

		local isMenuOpen2 = state4 and state5 == id2
		local createElement2 = React.createElement
		local v22 = {
			aspectRatio = "wide",
			mediaType = v21.mediaType,
			assetSource = v21.assetSource,
			isFilled = true,
			isSelected = isSelected,
			isLoading = state8[id2] or false,
			isMenuOpen = isMenuOpen2,
			menuItems = 0,
			onMenuActivated = 0,
			onMenuClose = 0,
			onSelect = 0,
			onEditPressed = 0,
			LayoutOrder = 0
		}
		local menuItems3

		if isMenuOpen2 then
			menuItems3 = menuItems
		end

		v22.menuItems = menuItems3
		v22.onMenuActivated = onMenuActivated
		v22.onMenuClose = onMenuClose
		function v22.onSelect()
			v16(id2)
		end
		v22.onEditPressed = (v9 or id2 ~= id) and function()
			v18(id2)
		end or nil

		v22.LayoutOrder = k + 1
		children[id2] = createElement2(FilmstripSlot, v22)
	end

	if v10 then
		local isMenuOpen2 = state4 and state5 == "empty"
		local createElement2 = React.createElement

		if not isMenuOpen2 then
			menuItems = nil
		end

		children.EmptySlot = createElement2(FilmstripSlot, {
			aspectRatio = "wide",
			mediaType = nil,
			assetSource = nil,
			isFilled = false,
			isSelected = false,
			isMenuOpen = isMenuOpen2,
			menuItems = menuItems,
			onMenuActivated = onMenuActivated,
			onMenuClose = onMenuClose,
			onSelect = v17,
			onEmptySlotPressed = v17,
			LayoutOrder = #v8 + 2
		})
	end

	local createElement2 = React.createElement
	local errorSnackbar

	if FFlagMediaSelectorErrorLogging and state9 ~= "" then
		errorSnackbar = React.createElement(
			View,
			{ tag = "row align-x-center size-full-0 auto-y padding-x-large", LayoutOrder = 0 },
			{
				Snackbar = React.createElement(Snackbar, {
					title = state9,
					onClose = onClose,
					testId = "MediaSelector.error-snackbar"
				})
			}
		)
	end

	return createElement2(View, { tag = "col gap-xlarge size-full" }, {
		ErrorSnackbar = errorSnackbar,
		Preview = React.createElement(View, {
			tag = {
				["align-x-center align-y-center fill size-full-0"] = true,
				["composition-content-body padding-y-xxlarge"] = true
			},
			LayoutOrder = 1,
			testId = "MediaSelector.Preview"
		}, {
			PreviewContent = React.createElement(MediaPreview, {
				mediaType = mediaType,
				assetSource = assetSource,
				isIcon = isIcon,
				isLoading = isLoading
			})
		}),
		Filmstrip = React.createElement(ScrollView, {
			tag = "size-full-0 auto-y",
			padding = {
				top = UDim.new(0, v6.Padding.XXLarge),
				bottom = UDim.new(0, v6.Padding.XXLarge),
				left = UDim.new(0, v.margin),
				right = UDim.new(0, v.margin)
			},
			LayoutOrder = 2,
			testId = "MediaSelector.Filmstrip",
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v6.Gap.Medium)
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.new(0, 0, 1, 0),
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = Foundation.Enums.Visibility.None
			}
		}, children)
	})
end

return IconThumbnailsEditor
