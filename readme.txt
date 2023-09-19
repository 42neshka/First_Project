Создание репозитория, синхронизация, ssh-key

Создание локального репозитория:
1. Создать папку
2. В git bash прописываем команды:
	1) переходим в созданную папку
	2) git init
	3) git status
	4) touch readme.txt
	5) git add --all либо git add readme.txt
	6) git commit -m ""
	7) git push
	
Создание удаленного репозитория:
1. New repo
2. git remote add origin <ssh link>
3. git remote -v
	# First_Project   git@github.com:42neshka/First_Project.git (fetch)
	# First_Project   git@github.com:42neshka/First_Project.git (push)

Подключение ssh ключей:
1. $ ls -la .ssh/ # вывели список созданных ключей если они есть
2. $ ssh-keygen -t ed25519 -C "электронная почта, к которой привязан ваш аккаунт на GitHub"  #создание ключа
3. $ ls -a ~/.ssh  # проверить наличие ключей
4. $ clip < ~/.ssh/<name_ssh_key>.pub  # скопировать содержимое ключа в буфер обмена:
5. Settings - SSH and GPG keys. Добавляем SSH
6. $ ssh -T git@github.com  # Проверьте правильность ключа с помощью следующей команды.
7. Hi %ВАШ_АККАУНТ%! You've successfully authenticated, but GitHub does not provide shell access.

PS. Если вышла ошибка Permission denied (publickey)
Убедитесь, что ssh-agent работает: В некоторых случаях требуется запуск ssh-agent и добавление ПРИВАТНОГО ключа.
   - Выполните команду `eval "$(ssh-agent -s)"` для запуска ssh-agent.
   - Если у вас есть приватный ключ с другим именем (не `id_rsa`), выполните команду `ssh-add <path_to_private_key>` для добавления ПРИВАТНОГО ключа в ssh-agent.
   
Синхронизация между удаленным репозиторием и локальным:
1. $ git push -u First_Project master  # или main ## -u ТОЛЬКО В ПЕРВЫЙ РАЗ


Полезные команды:
1. git log
2. git log --oneline сокращенный хэш