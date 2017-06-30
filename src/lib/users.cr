require "./user"

# Handle an user list and file associated
# TODO: mutex on add/remove/update
class Wikicr::Users
  class AlreadyExist < Exception
  end

  class NotExist < Exception
  end

  getter file : String
  @list : Hash(String, User)

  def initialize(@file)
    @list = {} of String => User
  end

  # read the users from the file (erase the modifications !)
  def read!
    @list = File.read(@file).split("\n")
                            .select { |line| !line.empty? }
                            .map { |line| u = User.new(line); {u.name, u} }.to_h
  end

  # save the users into the file
  def save!
    File.open(@file, "w") do |fd|
      @list.each { |name, user| user.to_s(fd) }
    end
  end

  # add an user to the list
  def add(u : User)
    raise AlreadyExist.new "User #{u.name} already exists" if (@list[u.name]?)
    @list[u.name] = u
  end

  # remove an user from the list
  # @see .remove(String)
  def remove(u : User)
    remove u.name
  end

  # remove an user from the list
  def remove(name : String)
    raise NotExist.new "User #{name} is not in the list" if (!@list[name]?)
    @list.remove(name)
  end

  # replace an entry
  def update(name : String, u : User)
    raise NotExist.new "User #{name} is not in the list" if (!@list[name]?)

    # if the name change
    if name != u.name
      add u # if it fails, remove will fail too
      remove name
    else
      @list[u.name] = u
    end
  end

  # find an user based on its name
  def find(name : String) : User
    raise NotExist.new "User #{name} is not in the list" if (!@list[name]?)
    @list[name]
  end

  # find an user by its name and check the password
  def auth?(name : String, password : String)
    find(name).password_encrypted == password
  end
end

# file = "/tmp/users"
# File.touch(file)
# include Wikicr
# users = Users.new(file)
# users.read!
# pp users
# user = User.new("arthur", "passwd", %w(admin,user)).encrypt
# users.add user
# users.save!
# p users
# pp Crypto::Bcrypt::Password.new(user.password) == "passwd"
# pp users.auth?("arthur", "passwd")
# pp users.auth?("arthur", "passwdx")
# pp users.auth?("arthurx", "passwd") # raise here