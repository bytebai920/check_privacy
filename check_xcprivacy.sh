# 提示用户输入包含搜索字符串的文件路径
read -p "请输入必要理由api的文件路径：" file_path

# 检查文件是否存在
if [ ! -f "$file_path" ]; then
  echo "错误：文件不存在。"
  exit 1
fi

# 逐行读取文件中的搜索字符串，并执行搜索操作
while IFS= read -r search_string; do
  # 检查搜索字符串是否以 "----" 开头
  if [[ "$search_string" == ----* ]]; then
    echo "${search_string}"
  else
    # 检查搜索字符串是否为空或只包含空格
    if [ -n "$(echo "$search_string" | tr -d '[:space:]')" ]; then
      # 指定要搜索的目录为当前目录
      search_directory="."

      # 对搜索字符串进行处理，确保空格被保留
      # 使用 printf 格式化字符串，%s 表示字符串
      formatted_search_string=$(printf "%s" "$search_string")

      # 使用 find 命令查找目录下的所有文件，并使用 grep 查找包含指定字符串的文件
      # -type f 表示只查找文件
      # -exec grep -H -i "$formatted_search_string" {} + 表示对每个找到的文件执行 grep 命令，输出包含匹配字符串的文件路径和匹配的行
      result=$(find "$search_directory" -type f -exec grep -H -i "$formatted_search_string" {} +)
        # 检查结果是否为空
        if [ -n "$result" ]; then
            echo "找到包含${formatted_search_string}符串的文件："
            echo "$result"
            echo "------------------------end------------------------"
        else
            echo "未找到包含${formatted_search_string}字符串的文件。"
            echo "------------------------------------------------"
        fi
    fi
  fi
done < "$file_path"

