RFX_REQUIRE("__test/unit/shared/cache.lua")
RFX_REQUIRE("__test/unit/shared/config.lua")
RFX_REQUIRE("__test/unit/shared/util/string.lua")
RFX_REQUIRE("__test/unit/shared/util/collection.lua")
RFX_REQUIRE("__test/unit/shared/util/table.lua")
RFX_REQUIRE("__test/unit/shared/util/translator.lua")

RFX_REQUIRE("__test/unit/server/log/logsystem.lua")

RFX_REQUIRE("__test/unit/server/core.lua")

RFX_REQUIRE("__test/unit/server/player/cplayer.lua")
RFX_REQUIRE("__test/unit/server/player/character/ccharacter.lua")

RFX_REQUIRE("__test/unit/server/inventory/itemstack.lua")
RFX_REQUIRE("__test/unit/server/inventory/inventory.lua")

RFX_REQUIRE("__test/unit/server/banking/account.lua")

RFX_REQUIRE("__test/unit/client/target/target.lua")
RFX_REQUIRE("__test/unit/client/target/targetmanager.lua")

RFX_REQUIRE("__test/unit/server/organization/organization.lua")

Test.runAll("TESTS")
