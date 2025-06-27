local simulation = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(simulation)
local resource = RESOURCE_LOAD(simulation, "./")
RESOURCE_START(resource)

local env = ENVIRONMENT_GET(server, resource)
local Translator = ENVIRONMENT_GET_VAR(env, "Translator")

Test.new('Translator should exist', function (self)
    return Test.assert(Translator ~= nil, "Translator should not be nil")
end)

Test.new('Translator.addTranslations should add translations', function (self)
    local translations = {
        hello = "Hello",
        world = "World"
    }
    Translator.addTranslations("en", translations)

    local translatedHello = Translator.translate("hello")
    local translatedWorld = Translator.translate("world")

    return Test.assertEqual(translatedHello, "Hello", "Translation for 'hello' should be 'Hello'") and
           Test.assertEqual(translatedWorld, "World", "Translation for 'world' should be 'World'")
end)

Test.new('Translator.translate should format translations with data', function (self)
    local translations = {
        greeting = "Hello, {name}!"
    }
    Translator.addTranslations("en", translations)

    local translatedGreeting = Translator.translate("greeting", { name = "Alice" })

    return Test.assertEqual(translatedGreeting, "Hello, Alice!", "Translation for 'greeting' should be 'Hello, Alice!'")
end)
