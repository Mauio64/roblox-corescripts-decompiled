local module = require("@luauforge/bundled/gvb")
local module2 = require("@luauforge/bundled/gwb")

local module3 = require("@luauforge/bundled/gwc")
local module4 = require("@luauforge/bundled/gwd")
local module5 = require("@luauforge/bundled/gwe")

return (module.createContext({
	api = module4,
	personaInquiryService = module5,
	openWebView = module2.openWebViewSession,
	externalBrowser = module3
}))
