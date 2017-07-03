require "./acl"
require "./group"

# Entity that have access to the ACL system.
module Wikicr::ACL::Entity
  # Returns `true` if the *group* is owned by the `Entity`, else `false`
  abstract def has_group?(group : String) : Bool

  # Returns the list of the group names of the `Entity`
  abstract def groups : Array(String)
end