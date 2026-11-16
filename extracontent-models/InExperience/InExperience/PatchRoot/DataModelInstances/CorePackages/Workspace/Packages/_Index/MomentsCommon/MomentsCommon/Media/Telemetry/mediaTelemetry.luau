local function noop() end

return {
	noopSink = {
		recordDownload = noop,
		recordDecode = noop,
		recordTimeToFirstFrame = noop,
		recordCache = noop,
		recordSoftwareFallback = noop,
		recordDwell = noop
	},
	createLoggingSink = function(callback)
		local v = callback or print
		return {
			recordDownload = function(data)
				v(`[media] download moment={data.momentId} kind={data.assetKind} dt={data.durationSeconds}s ok={data.success}`)
			end,
			recordDecode = function(data)
				v(`[media] decode moment={data.momentId} dt={data.durationSeconds}s ok={data.success}`)
			end,
			recordTimeToFirstFrame = function(p)
				v(`[media] ttff moment={p.momentId} dt={p.durationSeconds}s`)
			end,
			recordCache = function(data)
				v(`[media] cache moment={data.momentId} stage={data.stage} kind={data.assetKind} hit={data.hit}`)
			end,
			recordSoftwareFallback = function(p)
				v(`[media] software-fallback moment={p.momentId}`)
			end,
			recordDwell = function(p)
				v(`[media] dwell moment={p.momentId} dt={p.durationSeconds}s`)
			end
		}
	end
}
