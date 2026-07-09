local function noop() -- line: 52
end

return {
	noopSink = {
		recordDownload = noop,
		recordDecode = noop,
		recordTimeToFirstFrame = noop,
		recordCache = noop,
		recordSoftwareFallback = noop,
		recordDwell = noop
	},
	createLoggingSink = function(p1: ((...any) -> ...any)?) -- line: 63
		local v3 = p1 or print

		return {
			recordDownload = function(p2) -- line: 67
				-- upvalues: v3 (copy)
				v3(`[media] download moment={ p2.momentId } kind={ p2.assetKind } dt={ p2.durationSeconds }s ok={ p2.success }`)
			end,
			recordDecode = function(p3) -- line: 72
				-- upvalues: v3 (copy)
				v3(`[media] decode moment={ p3.momentId } dt={ p3.durationSeconds }s ok={ p3.success }`)
			end,
			recordTimeToFirstFrame = function(p4) -- line: 75
				-- upvalues: v3 (copy)
				v3(`[media] ttff moment={ p4.momentId } dt={ p4.durationSeconds }s`)
			end,
			recordCache = function(p5) -- line: 78
				-- upvalues: v3 (copy)
				v3(`[media] cache moment={ p5.momentId } stage={ p5.stage } kind={ p5.assetKind } hit={ p5.hit }`)
			end,
			recordSoftwareFallback = function(p6) -- line: 81
				-- upvalues: v3 (copy)
				v3(`[media] software-fallback moment={ p6.momentId }`)
			end,
			recordDwell = function(p7) -- line: 84
				-- upvalues: v3 (copy)
				v3(`[media] dwell moment={ p7.momentId } dt={ p7.durationSeconds }s`)
			end
		}
	end
}
