#Область ПрограммныйИнтерфейс

// ЗаменитьФайлВИнформационнойБазе осуществляет поиск и замену внешних обработок по имени файла
// и возвращает описание результата данной замены.
//
// Параметры:
// 	ИмяФайла - Строка - полное имя файла, по которому осуществляется поисх в информационной базе;
// 	Данные - ДвоичныеДанные - тело файла;
//
// Возвращаемое значение:
// 	- Структура - описание:
// 		* filename - Строка - полное имя файла;
// 		* uploaded - Массив из Структура - результаты успешной загрузки файла:
// 			** ref - Строка - идентификатор ссылки на элемент справочника; 
// 			** line - Число - номер строки табличной части,
// 								0 - если файл загружается непосредственно в элемент справочника; 
// 		* errors - Массив из Структура - ошибки загрузки файла:
// 			** ref - Строка - идентификатор ссылки на элемент справочника; 
// 			** line - Число - номер строки табличной части,
// 								0 - если файл загружается непосредственно в элемент справочника; 
// 			** message - Строка - текст ошибки;		
// 		* message - Строка - информационное сообщение;
//
Функция ЗаменитьФайлВИнформационнойБазе( Знач ИмяФайла, Знач Данные ) Экспорт
	
	Перем ЭлементыСправочника;
	Перем ИмяВременногоФайла;
	Перем Файл;
	Перем СхемаПутьКРеквизиту;
	Перем Результат;

	СООБЩЕНИЕ_УСПЕХ = НСтр( "ru = 'внешние обработки загружены успешно';
							|en = 'external data processors uploaded successfully'" );	
	СООБЩЕНИЕ_ОБРАБОТКИ_НЕ_НАЙДЕНЫ = НСтр( "ru = 'внешние обработки не найдены';
											|en = 'no external data processors found'" );
	
	Результат = ПолучитьСхемуЗагрузкаФайла( ИмяФайла );
	
	ЭлементыСправочника = Справочники.ВнешниеОбработки.НайтиПоИмениФайла( ИмяФайла );
	
	Если ( НЕ ЗначениеЗаполнено(ЭлементыСправочника) ) Тогда
		
		УстановитьСообщение( Результат, СООБЩЕНИЕ_ОБРАБОТКИ_НЕ_НАЙДЕНЫ );
		
		Возврат Результат;
		
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла( "epf" );

	Файл = ЗаписатьДанныеВоВременныйФайл( ИмяВременногоФайла, Данные );
	
	Для Каждого ПутьКРеквизиту Из ЭлементыСправочника Цикл
		
		Попытка
			
			Справочники.ВнешниеОбработки.СохранитьВнешнююОбработку( ПутьКРеквизиту, ИмяФайла, Файл, Данные );
			Результат.uploaded.Добавить( ПолучитьСхемуПутьКРеквизиту(ПутьКРеквизиту) );
			УстановитьСообщение( Результат, СООБЩЕНИЕ_УСПЕХ );
			
		Исключение
	
			СхемаПутьКРеквизиту = ПолучитьСхемуПутьКРеквизиту( ПутьКРеквизиту );
			УстановитьСообщение( СхемаПутьКРеквизиту, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()) );
			Результат.errors.Добавить( СхемаПутьКРеквизиту );
			
		КонецПопытки;
	
	КонецЦикла;

	УдалитьФайлы( ИмяВременногоФайла );		
	
	Возврат Результат;

КонецФункции

// УстановитьЗагружатьФайлыИзВнешнегоХранилища включает/отключает функционал загрузки файлов
// из внешнего хранилища и возвращает описание результата выполнения данной операции.
// 
// Параметры:
// 	Значение - Булево - Истина - включить, Ложь - отключить;
// 	
// Возвращаемое значение:
// 	- Структура - описание:
// 		* message - Строка - информационное сообщение;
//
Функция УстановитьЗагружатьФайлыИзВнешнегоХранилища( Знач Значение ) Экспорт
	
	Перем Результат;

	СООБЩЕНИЕ_ВКЛЮЧЕНО = НСтр( "ru = 'загрузка файлов включена';en = 'file uploads enabled '" );
	СООБЩЕНИЕ_ОТКЛЮЧЕНО = НСтр( "ru = 'загрузка файлов отключена';en = 'file uploads disabled'" );
	
	Константы.ЗагружатьФайлыИзВнешнегоХранилища.Установить( Значение );
	
	Результат = Новый Структура();
	
	Если ( Константы.ЗагружатьФайлыИзВнешнегоХранилища.Получить() ) Тогда
		
		УстановитьСообщение( Результат, СООБЩЕНИЕ_ВКЛЮЧЕНО );
		
	Иначе
		
		УстановитьСообщение( Результат, СООБЩЕНИЕ_ОТКЛЮЧЕНО );
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// GetJson сериализует данные в формате json.
// 
// Параметры:
// 	Данные - Структура - произвольная структура;
// 	
// Возвращаемое значение:
// 	Строка - результат сериализации в формате json;
//
Функция GetJson( Знач Данные ) Экспорт
	
	Перем ПараметрыЗаписи;
	Перем Запись;
	Перем Результат;
	
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON( ПереносСтрокJSON.Нет );
	Запись = Новый ЗаписьJSON();
	Запись.УстановитьСтроку( ПараметрыЗаписи );
	ЗаписатьJSON( Запись, Данные );
	
	Результат = Запись.Закрыть();

	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСхемуЗагрузкаФайла( Знач ИмяФайла )
	
	Перем Результат;
	
	Результат = Новый Структура();
	Результат.Вставить( "filename", ИмяФайла );
	Результат.Вставить( "uploaded", Новый Массив() );
	Результат.Вставить( "errors", Новый Массив() );

	Возврат Результат;	
	
КонецФункции

Функция ПолучитьСхемуПутьКРеквизиту( Знач Адрес )
	
	Перем Результат;
	
	Результат = Новый Структура();
	Результат.Вставить( "ref", Строка(Адрес.Ссылка.УникальныйИдентификатор()) );
	Результат.Вставить( "line", Адрес.НомерСтроки );

	Возврат Результат;	
	
КонецФункции

Процедура УстановитьСообщение( СхемаОтвета, Знач Сообщение )
	
	СхемаОтвета.Вставить( "message", Сообщение );
	
КонецПроцедуры

Функция ЗаписатьДанныеВоВременныйФайл( Знач ИмяВременногоФайла, Данные )
	
	Перем Файл;
	
	Файл = Новый Файл( ИмяВременногоФайла );
	
	Попытка
		
		Данные.Записать( Файл.ПолноеИмя );	
	
	Исключение
		
		УдалитьФайлы( ИмяВременногоФайла );
		
		ВызватьИсключение;
		
	КонецПопытки;
	
	Возврат Файл;
	
КонецФункции

#КонецОбласти
