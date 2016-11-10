module MailerHelper
  def this_thing(collection)
    collection.many? ? "these things" : "this thing"
  end
end
