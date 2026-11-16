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
	createLoggingSink = function(p2)
		local v5 = p2 or print
		return {
			recordDownload = function(data)
				v5(`[media] download moment={data.momentId} kind={data.assetKind} dt={data.durationSeconds}s ok={data.success}`)
			end,
			recordDecode = function(data)
				v5(`[media] decode moment={data.momentId} dt={data.durationSeconds}s ok={data.success}`)
			end,
			recordTimeToFirstFrame = function(p3)
				v5(`[media] ttff moment={p3.momentId} dt={p3.durationSeconds}s`)
			end,
			recordCache = function(data)
				v5(`[media] cache moment={data.momentId} stage={data.stage} kind={data.assetKind} hit={data.hit}`)
			end,
			recordSoftwareFallback = function(p3)
				v5(`[media] software-fallback moment={p3.momentId}`)
			end,
			recordDwell = function(p3)
				v5(`[media] dwell moment={p3.momentId} dt={p3.durationSeconds}s`)
			end
		}
	end
}
