local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppComposition")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local useCompositionLayout = AppComposition.useCompositionLayout

local scrollView = Foundation.ScrollView
local view = Foundation.View

local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local getGameMediaStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration").Game.getGameMediaStore
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")

local createGalleryCaptureSource = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Moments/createGalleryCaptureSource")

local useTokens = Foundation.Hooks.useTokens
local getGameMediaForUniverse = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getGameMediaForUniverse")
local useMediaUpdater = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useMediaUpdater")

local uploadCaptureAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/uploadCaptureAsync")
local getThumbnailUrlAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getThumbnailUrlAsync")
local createImageAssetAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/createImageAssetAsync")

local CaptureSelectionView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/CaptureSelectionView")
local FilmstripSlot = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/FilmstripSlot")
local MediaPreview = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/MediaPreview")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/types")

local FFlagMediaSelectorErrorLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagMediaSelectorErrorLogging")

local formatError = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/formatError")
local snackbar = Foundation.Snackbar

local function IconThumbnailsEditor(p2)
	local v5 = useCompositionLayout()
	local v6 = useLocalization({
		captureLibrary = LocalizationStrings.MEDIA_SELECTION_CAPTURE_LIBRARY,
		delete = LocalizationStrings.MEDIA_SELECTION_DELETE
	})
	local v7

	if FFlagMediaSelectorErrorLogging then
		v7 = useLocalization({ mediaError = "Feature.Moments.Label.Error" })
	else
		v7 = nil
	end

	local captureLibrary = v6.captureLibrary
	local delete = v6.delete
	local v8 = getGameMediaForUniverse(p2.universeId)
	local v9 = React.useMemo(function()
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(p2.universeId)
	end, { p2.universeId })
	local v10 = SignalsReact.useSignalState(v9.data)
	local rootPlaceId = if v10 then tostring(v10.rootPlaceId) else nil

	local v11 = useTokens()
	local state, setState = React.useState(v8.icon)
	local state2, setState2 = React.useState(v8.thumbnails)
	local state3, setState3 = React.useState({ kind = "icon" })
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(nil)
	local state6, setState6 = React.useState("editor")
	local state7, setState7 = React.useState(nil)
	local state8, setState8 = React.useState({})
	local state9, setState9 = React.useState("")
	local ref = React.useRef(0)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(#v8.thumbnails + 1)

	local ref4 = React.useRef(nil)

	if ref4.current == nil then
		ref4.current = createGalleryCaptureSource(nil, nil, { Enum.CaptureType.Screenshot })
	end

	local ref5 = React.useRef(state2)
	ref5.current = state2
	local useRef = React.useRef(state)
	useRef.current = state

	local v12 = useMediaUpdater()

	React.useEffect(function()
		if ref.current ~= 0 then
			return
		end

		setState2(v8.thumbnails)
	end, { v8.thumbnails })

	React.useEffect(function()
		if ref.current == 0 then
			setState(v8.icon)
		end
	end, { v8.icon })

	local v13 = React.useMemo(function()
		local result = {}

		for k, v14 in state2 do
			table.insert(result, v14)
		end

		return result
	end, { state2 })
	local v14 = rootPlaceId ~= nil
	local v15 = #v13 < 10 and v14

	local id = if v13[1] then v13[1].id else nil

	local v16 = React.useCallback(function(p3, p4)
		setState8(function(p5)
			local clone = table.clone(p5)
			clone[p3] = p4 and true or nil
			return clone
		end)
	end, {})

	local v17 = React.useCallback(function()
		ref.current += 1
	end, {})

	local v18 = React.useCallback(function()
		ref.current = math.max(0, ref.current - 1)
	end, {})

	local v19 = React.useCallback(function()
		setState9("")
	end, {})

	local v20 = React.useCallback(function(p3)
		local v21 = {}

		if v14 then
			table.insert(v21, {
				id = "capture_library",
				text = captureLibrary,
				icon = "icons/common/image"
			})
		end

		if p3 ~= "icon" and p3 ~= id and p3 ~= "empty" then
			table.insert(v21, {
				id = "delete",
				text = delete,
				icon = "icons/common/trash"
			})
		end

		return {
			{ items = v21 }
		}
	end, { v14, captureLibrary, delete, id })

	local v21 = React.useCallback(function(p3)
		if state8[p3] or ref2.current and p3 ~= "icon" and p3 ~= "empty" then
			return
		end

		setState5(p3)
		setState4(true)
	end, { state8 })

	local v22 = React.useCallback(function(p3)
		setState4(false)

		if ref2.current and state5 ~= "icon" and state5 ~= "empty" then
			return
		end

		if p3 == "capture_library" and v14 then
			setState7(state5)
			setState6("captureSelection")
		elseif p3 == "delete" then
			local v23 = state5

			if v23 == nil or rootPlaceId == nil or state8[v23] then
				return
			end

			local v24 = nil
			local v25 = nil

			for k, v27 in state2 do
				if v27.id == v23 then
					v25 = v27
					v24 = k
					break
				end
			end

			if v24 == nil or v25 == nil or not v25.assetResourceName then
				return
			end

			local assetResourceName = v25.assetResourceName
			ref2.current = true
			v17()
			v16(v23, true)
			setState2(function(items)
				local result = {}

				for k, item in items do
					if item.id ~= v23 then
						table.insert(result, item)
					end
				end

				return result
			end)

			if state3.kind == "thumbnail" and state3.id == v23 then
				setState3({ kind = "icon" })
			end

			v12.removePreview(rootPlaceId, assetResourceName):andThen(function()
				getGameMediaStore().fetchGameMedia((tostring(p2.universeId)))
			end):catch(function(p4)
				if FFlagMediaSelectorErrorLogging then
					warn(`[BuildExperience] MediaSelector delete failed: {module18(p4)}`)
					setState9(v7.mediaError)
				end

				setState2(function(items)
					for k, item in items do
						if item.id == v23 then
							return items
						end
					end

					local clone = table.clone(items)
					table.insert(clone, math.min(v24, #clone + 1), v25)
					return clone
				end)
			end):finally(function()
				ref2.current = false
				v16(v23, false)
				v18()
			end)
		end
	end, {
		state5,
		state3,
		state2,
		v12,
		rootPlaceId,
		v14,
		state8,
		v17,
		v18,
		v16,
		v7,
		p2.universeId
	})

	local v23 = React.useCallback(function()
		setState4(false)
	end, {})

	local v24 = React.useCallback(function()
		setState3({ kind = "icon" })
	end, {})

	local v25 = React.useCallback(function(p3)
		setState3({ kind = "thumbnail", id = p3 })
	end, {})

	local v26 = React.useCallback(function()
		v21("icon")
	end, { v21 })

	local v27 = React.useCallback(function()
		v21("empty")
	end, { v21 })

	local v28 = React.useCallback(function(p3)
		v21(p3)
	end, { v21 })

	local v29 = React.useCallback(function(p3)
		local v30 = state7

		if v30 == nil or rootPlaceId == nil or state8[v30] then
			return
		end

		setState6("editor")
		setState7(nil)

		local v31 = nil
		local v32 = nil

		if v30 ~= "icon" and v30 ~= "empty" then
			for k, v34 in ref5.current do
				if v34.id == v30 then
					v32 = v34
					v31 = k
					break
				end
			end

			if v31 == nil or v32 == nil or not v32.assetResourceName then
				return
			end
		end

		local v33

		if v30 == "empty" then
			v33 = `thumbnail_pending_{ref3.current}`
			ref3.current += 1
		else
			v33 = v30
		end

		v17()
		v16(v33, true)

		if v30 == "icon" then
			setState3({ kind = "icon" })
		elseif v30 == "empty" then
			setState2(function(p4)
				local clone = table.clone(p4)
				table.insert(clone, { id = v33, mediaType = "image", assetSource = nil })

				return clone
			end)

			setState3({ kind = "thumbnail", id = v33 })
		else
			setState2(function(p4)
				local clone = table.clone(p4)

				for k, v34 in clone do
					if v34.id == v30 then
						clone[k] = {
							id = v34.id,
							mediaType = "image",
							assetSource = nil
						}

						return clone
					end
				end

				return clone
			end)
		end

		local v34 = uploadCaptureAsync(p3):andThen(function(p4)
			return getThumbnailUrlAsync(p4.assetId)
		end):andThen(function(p4)
			if typeof(p4) == "table" and p4.status == "in_review" then
				return Promise.reject({
					code = "IN_REVIEW",
					message = "Capture is under moderation review"
				})
			end

			local imageUrl = p4.imageUrl

			local v35 = v10 and {
					creatorType = v10.creatorType,
					creatorTargetId = v10.creatorTargetId
				}
				or nil

			return createImageAssetAsync(imageUrl, nil, v30 == "icon", v35):andThen(function(p5)
				return { imageAssetId = tostring(p5.assetId), displayUrl = imageUrl }
			end)
		end)

		local v35 = v34:andThen(function(p4)
			return p4.imageAssetId
		end)
		local v36

		if v30 == "icon" then
			v36 = v12.setIcon(rootPlaceId, v35)
		elseif v30 == "empty" then
			v36 = v12.addPreview(rootPlaceId, v35)
		else
			v36 = v12.replacePreview(rootPlaceId, v35, v32.assetResourceName)
		end

		v36:andThen(function()
			return v34
		end):andThen(function(p4)
			if v30 == "icon" then
				setState(p4.displayUrl)
			else
				local imageAssetId = p4.imageAssetId
				setState2(function(p5)
					local clone = table.clone(p5)

					for k, v37 in clone do
						if v37.id == v33 then
							clone[k] = {
								id = imageAssetId,
								mediaType = "image",
								assetSource = p4.displayUrl,
								assetResourceName = `assets/{p4.imageAssetId}`
							}

							return clone
						end
					end

					return clone
				end)

				setState3(function(p5)
					if p5.kind == "thumbnail" and p5.id == v33 then
						return { kind = "thumbnail", id = imageAssetId }
					end

					return p5
				end)
			end

			getGameMediaStore().fetchGameMedia((tostring(p2.universeId)))
		end):catch(function(p4)
			if FFlagMediaSelectorErrorLogging then
				warn(`[BuildExperience] MediaSelector upload failed: {module18(p4)}`)
				setState9(v7.mediaError)
			end

			if v30 == "icon" then
				return
			end

			if v30 == "empty" then
				setState2(function(items)
					local result = {}

					for k, item in items do
						if item.id ~= v33 then
							table.insert(result, item)
						end
					end

					return result
				end)

				setState3(function(p5)
					if p5.kind == "thumbnail" and p5.id == v33 then
						return { kind = "icon" }
					end

					return p5
				end)
			else
				local v37 = v32
				setState2(function(p5)
					local clone = table.clone(p5)

					for k, v38 in clone do
						if v38.id == v33 then
							clone[k] = v37
							return clone
						end
					end

					return clone
				end)
			end
		end):finally(function()
			v16(v33, false)
			v18()
		end)
	end, {
		state7,
		v12,
		rootPlaceId,
		v10,
		state8,
		v17,
		v18,
		v16,
		v7,
		p2.universeId
	})

	local v30 = React.useCallback(function()
		setState6("editor")
		setState7(nil)
	end, {})

	React.useEffect(function()
		local backHandlerRef = p2.backHandlerRef

		if backHandlerRef then
			local v31 = if state6 == "captureSelection" then v30 else nil
			backHandlerRef.current = v31
		end

		return function()
			if backHandlerRef then
				backHandlerRef.current = nil
			end
		end
	end, { state6, v30, p2.backHandlerRef })

	local v31 = React.useMemo(function()
		if state5 then
			return v20(state5)
		end

		return {
			{ items = {} }
		}
	end, { state5, v20 })

	if state6 == "captureSelection" then
		return React.createElement(CaptureSelectionView, {
			captureSource = ref4.current,
			onCaptureConfirmed = v29
		})
	end

	local v32 = nil
	local v33 = nil
	local v34 = false
	local v35 = false

	if state3.kind == "icon" then
		v35 = state8.icon or false
		v33 = state
		v32 = "image"
		v34 = true
	elseif state3.kind == "thumbnail" then
		for k, v37 in v13 do
			if v37.id == state3.id then
				v32 = v37.mediaType
				v33 = v37.assetSource
				v35 = state8[v37.id] or false
				break
			end
		end
	end

	local children = {}
	local v36 = state4 and state5 == "icon"
	local createElement = React.createElement
	local v38 = {
		aspectRatio = "square",
		mediaType = "image",
		assetSource = state,
		isFilled = true,
		isSelected = state3.kind == "icon",
		isLoading = state8.icon or false,
		isMenuOpen = v36,
		menuItems = if v36 then v31 else nil,
		onMenuActivated = v22,
		onMenuClose = v23,
		onSelect = v24,
		onEditPressed = 0,
		LayoutOrder = 1
	}

	if not v14 then
		v26 = nil
	end

	v38.onEditPressed = v26
	children.IconSlot = createElement(FilmstripSlot, v38)

	for k, v40 in v13 do
		local id2 = v40.id
		local v41 = state3.kind == "thumbnail" and state3.id == id2
		local v42 = state4 and state5 == id2
		children[id2] = React.createElement(FilmstripSlot, {
			aspectRatio = "wide",
			mediaType = v40.mediaType,
			assetSource = v40.assetSource,
			isFilled = true,
			isSelected = v41,
			isLoading = state8[id2] or false,
			isMenuOpen = v42,
			menuItems = if v42 then v31 else nil,
			onMenuActivated = v22,
			onMenuClose = v23,
			onSelect = function()
				v25(id2)
			end,
			onEditPressed = (v14 or id2 ~= id) and function()
				v28(id2)
			end or nil,
			LayoutOrder = k + 1
		})
	end

	if v15 then
		local v40 = state4 and state5 == "empty"
		local createElement2 = React.createElement

		if not v40 then
			v31 = nil
		end

		children.EmptySlot = createElement2(FilmstripSlot, {
			aspectRatio = "wide",
			mediaType = nil,
			assetSource = nil,
			isFilled = false,
			isSelected = false,
			isMenuOpen = v40,
			menuItems = v31,
			onMenuActivated = v22,
			onMenuClose = v23,
			onSelect = v27,
			onEmptySlotPressed = v27,
			LayoutOrder = #v13 + 2
		})
	end

	local createElement2 = React.createElement

	local v42 = if FFlagMediaSelectorErrorLogging and state9 ~= "" then React.createElement(
		view,
		{
			tag = "row align-x-center size-full-0 auto-y padding-x-large",
			LayoutOrder = 0
		},
		{
			Snackbar = React.createElement(snackbar, {
				title = state9,
				onClose = v19,
				testId = "MediaSelector.error-snackbar"
			})
		}
	) else nil
	return createElement2(view, { tag = "col gap-xlarge size-full" }, {
		ErrorSnackbar = v42,
		Preview = React.createElement(view, {
			tag = {
				["align-x-center align-y-center fill size-full-0"] = true,
				["composition-content-body padding-y-xxlarge"] = true
			},
			LayoutOrder = 1,
			testId = "MediaSelector.Preview"
		}, {
			PreviewContent = React.createElement(MediaPreview, {
				mediaType = v32,
				assetSource = v33,
				isIcon = v34,
				isLoading = v35
			})
		}),
		Filmstrip = React.createElement(scrollView, {
			tag = "size-full-0 auto-y",
			padding = {
				top = UDim.new(0, v11.Padding.XXLarge),
				bottom = UDim.new(0, v11.Padding.XXLarge),
				left = UDim.new(0, v5.margin),
				right = UDim.new(0, v5.margin)
			},
			LayoutOrder = 2,
			testId = "MediaSelector.Filmstrip",
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v11.Gap.Medium)
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
