#Project description

[Trello](https://trello.com/b/8j9K5XaA/onenewthing)

#Community Slack

[CodeLikeNoob](http://codelikenoob.frey.su/)

#Contributing

1. Fork and/or clone it (`git clone git@github.com:codelikenoob/onenewthing.git`)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'my-new-feature description'`)
4. Push to the remote branch (`git push origin my-new-feature`)
5. Create new Pull Request

#Avaible rake tasks

###Adding things to the database
To add things to the database perform
```bash
rails db:add_things[**count**]
```
It would create 10 records if argument not passed.
If you're using `zsh` or `fish`, you might need to call this command from pure `bash`:
```bash
bash && rails db:add_things[**count**] && zsh
```
