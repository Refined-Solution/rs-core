---@class Translator
Translator = {}
Translator.__index = Translator

---@type table<string, table<string, string>> all the translations for each language
local dictionary = {}

---Adds new translations for the given language.
---@param language string the language to add translations for
---@param translations table<string, string> a table containing the translations for the language
function Translator.addTranslations(language, translations)
    if not dictionary[language] then
        dictionary[language] = {}
    end

    for key, value in pairs(translations) do
        dictionary[language][key] = value
    end
end

---Translates the given key using the current language.
---@nodiscard
---@param key string the key to translate
---@param data? table<string, any> optional data to format the translation with
---@return string translation the translated string, or the key if no translation is found
function Translator.translate(key, data)
    local language = Config.General.language
    local translations = dictionary[language]

    if not translations then
        error(
            StringUtils.format(
                "Language '{language}' not found.",
                { language = language }
            )
        )
    end

    local translation = translations[key]
    if not translation then
        error(
            StringUtils.format(
                "Translation for key '{key}' not found in language '{language}'.",
                { key = key, language = language }
            )
        )
    end

    data = data or {}
    return StringUtils.format(translation, data)
end
