local verificationPresentation = {
	Native = "Native",
	InAppWebView = "InAppWebView",
	ExternalLink = "ExternalLink"
}

return {
	VerificationPresentation = verificationPresentation,
	resolveVerificationPresentation = function(flag: boolean, flag2: boolean)
		if flag then
			return verificationPresentation.Native
		end

		if flag2 then
			return verificationPresentation.InAppWebView
		end

		return verificationPresentation.ExternalLink
	end
}
