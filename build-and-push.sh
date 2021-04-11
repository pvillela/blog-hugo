#! /bin/bash -e

# Run hugo to build public, commit public repo, push public repo, commit blog-hugo repo,
# push blog-hugo repo.

hugo

git status

while true; do
    read -p "Do you want to proceed with committing and pushing? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

cd public
git add .
read -p "Enter commit message: " COMMIT_MSG
git commit -m "$COMMIT_MSG"
read -p "Enter GitHub passcode: " PASSCODE
echo "https://pvillela:${PASSCODE}@github.com/pvillela/blog.git"
git push https://pvillela:${PASSCODE}@github.com/pvillela/blog.git gh-pages

cd ..
git add .
git commit -m "$COMMIT_MSG"
git push https://pvillela:${PASSCODE}@github.com/pvillela/blog-hugo.git main
git status

