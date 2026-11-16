local CoreScriptsPlayerFeedback = script:FindFirstAncestor("CoreScriptsPlayerFeedback")
local parent = CoreScriptsPlayerFeedback.Parent

local React = require(parent.React)

require(CoreScriptsPlayerFeedback.CaptureTypes)
local getCaptureKey = require(CoreScriptsPlayerFeedback.Utils.getCaptureKey)
local uploadCaptureAsset = require(CoreScriptsPlayerFeedback.Utils.uploadCaptureAsset)

local function useCaptureUploads()
	local state, setState = React.useState({})

	local ref = React.useRef({})

	local ref2 = React.useRef({})
	local ref3 = React.useRef(0)

	return {
		uploadStatuses = state,
		anyUploading = React.useMemo(function(): boolean
			for _, v in state do
				if v.status == "uploading" then
					return true
				end
			end

			return false
		end, { state }),
		hasNonModerationFailure = React.useMemo(function(): boolean
			for _, v in state do
				if v.status == "failed" and v.failureReason ~= Enum.UploadCaptureResult.CaptureModerated then
					return true
				end
			end

			return false
		end, { state }),
		onCapturesAdded = React.useCallback(function(items)
			local v = {}

			for _, item in items do
				v[getCaptureKey(item)] = item
			end

			local v2 = {}

			for k, v3 in v do
				if state[k] == nil then
					table.insert(v2, v3)
				end
			end

			setState(function(items2)
				local result = {}

				for k, item in items2 do
					if v[k] then
						result[k] = item
					end
				end

				local order = 0

				for _, item in items2 do
					if item.order and order < item.order then
						order = item.order
					end
				end

				for _, capture in v2 do
					order += 1
					local captureKey = getCaptureKey(capture)
					local v3 = ref.current[captureKey]

					if v3 then
						result[captureKey] = {
							capture = capture,
							status = v3.status,
							assetId = v3.assetId,
							failureReason = v3.failureReason,
							order = order
						}
					else
						result[captureKey] = {
							capture = capture,
							status = "uploading",
							assetId = nil,
							order = order
						}
					end
				end

				return result
			end)

			for _, capture in v2 do
				local captureKey = getCaptureKey(capture)

				if ref.current[captureKey] or ref2.current[captureKey] then
					continue
				end

				ref3.current += 1
				local current = ref3.current
				ref2.current[captureKey] = current
				task.spawn(function()
					local assetId, failureReason = uploadCaptureAsset(capture)

					if ref2.current[captureKey] ~= current then
						return
					end

					ref2.current[captureKey] = nil
					local v3 = {
						capture = capture,
						status = assetId == nil and "failed" or "succeeded",
						failureReason = failureReason,
						assetId = assetId,
						order = nil
					}

					if assetId ~= nil or failureReason == Enum.UploadCaptureResult.CaptureModerated then
						ref.current[captureKey] = v3
					end

					setState(function(p)
						if not p[captureKey] then
							return p
						end

						local clone = table.clone(p)
						clone[captureKey] = {
							capture = capture,
							status = v3.status,
							failureReason = v3.failureReason,
							assetId = v3.assetId,
							order = p[captureKey] and p[captureKey].order
						}

						return clone
					end)
				end)
			end
		end, { state }),
		onCaptureRemoved = React.useCallback(function(p: string)
			setState(function(p2)
				local clone = table.clone(p2)
				clone[p] = nil
				return clone
			end)
		end, {})
	}
end

return useCaptureUploads
