local v5 = {
	Native = "Native",
	InAppWebView = "InAppWebView",
	ExternalLink = "ExternalLink"
}

return {
	VerificationPresentation = v5,
	resolveVerificationPresentation = function(p2, p3)
		if p2 then
			return v5.Native
		end

		if p3 then
			return v5.InAppWebView
		end

		return v5.ExternalLink
	end
}
