require "./acl"

# The Group is identified by a *name* and has *permissions* on a set of paths.
# It is used by `Groups`.
# NOTE: I did not used Hash().new(default) because it is annoying with passing the permissions in the constructor
class Wikicr::ACL::Group
  getter name : String
  getter permissions : Hash(String, ACL::Perm)
  property default : ACL::Perm

  # Create a new named Group with optional parameters.
  #
  # - *name* is the name of the group (arbitrary `String`).
  # - *permissions* is a hash of ``{"path" => `Perm`}``.
  # - *default* is the value used for every path not defined in the *permissions*.
  def initialize(@name,
                 @permissions = Hash(String, ACL::Perm).new,
                 @default : ACL::Perm = ACL::Perm::None)
  end

  # Check if the group as the `ACL::Perm` required to have access to a given path.
  #
  # - *path* is the path that must be checked
  # - *access* is the minimal `ACL::Perm` required for a given operation
  def permitted?(path : String, access : ACL::Perm) : Bool
    permissions.fetch(path, default).to_i >= access.to_i
  end

  # def if_permitted(path : String, access : ACL::Perm) : Bool
  #   yield if permitted? path, access
  # end
end