
#
# Testing OpenWFE
#
# John Mettraux at openwfe.org
#
# Mon May 12 14:12:54 JST 2008
#

require 'rubygems'

require 'test/unit'

require 'openwfe/util/treechecker'

#
# testing expression conditions
#

class TreeCheckerTest < Test::Unit::TestCase

    #def setup
    #end

    #def teardown
    #end

    def test_0

        assert_safe :check, "1+1"
        assert_unsafe :check, "exit"
        assert_unsafe :check, "puts $BATEAU"
        assert_unsafe :check, "def surf }"
        assert_unsafe :check, "abort"
        assert_unsafe :check, "abort; puts 'ok'"
        assert_unsafe :check, "puts 'ok'; abort"

        assert_unsafe :check, "exit 0"
        assert_unsafe :check, "system('whatever')"

        assert_unsafe :check, "alias :a :b"
        assert_unsafe :check, "alias_method :a :b"

        assert_unsafe :check, "File.open('x')"
        assert_unsafe :check, "FileUtils.rm('x')"

        assert_unsafe :check, "eval 'nada'"
        assert_unsafe :check, "M.module_eval 'nada'"
        assert_unsafe :check, "o.instance_eval 'nada'"
    end

    def test_1

        assert_safe :check_conditional, "1 == 1"
        assert_unsafe :check_conditional, "puts 'ok'; 1 == 1"
        assert_unsafe :check_conditional, "exit"
        assert_unsafe :check_conditional, "a = 2"
    end

    def test_2

        assert_safe :check, "class Toto < OpenWFE::ProcessDefinition\nend"
        assert_unsafe :check, "class String\nend"
        assert_unsafe :check, "module Whatever\nend"
        assert_unsafe :check, "class << e\nend"
    end

    protected

        def assert_safe (check_method, code)

            assert check(check_method, code)
        end

        def assert_unsafe (check_method, code)

            assert (not check(check_method, code))
        end

        def check (check_method, code)

            begin

                OpenWFE::TreeChecker.send check_method, code

            rescue Exception => e
                #puts e
                #puts e.backtrace
                return false
            end

            true
        end
end