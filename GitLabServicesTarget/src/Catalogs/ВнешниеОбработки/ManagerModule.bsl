#Область ПрограммныйИнтерфейс

// Поиск элементов справочника по наименованию внешнего файла-источника данных (обработка, отчет, печатная форма)
// 
// Параметры:
// 	СтрокаПоиска - Строка - шаблон поиска, допускаются спецсимволы аналогичные конструкции ПОДОБНО языка запросов
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание:
// * Ссылка - СправочникСсылка.ВнешниеОбработки - ссылка на элемент справочника
// * НомерСтроки - Число - номер строки в табличной части Принадлежность элемента справочника
//
Функция НайтиПоИмениФайлаИсточника(Знач СтрокаПоиска = "") Экспорт
	
	Перем Запрос;
	Перем РезультатЗапроса;
	Перем Результат;
	
	Результат = ОписаниеРезультатаПоискаЭлементовПоИмениФайлаИсточника();
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтрокаПоиска", СтрокаПоиска);
	Запрос.Текст =	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	              	|	ВнешниеОбработки.Ссылка КАК Ссылка,
	              	|	0 КАК НомерСтроки
	              	|ИЗ
	              	|	Справочник.ВнешниеОбработки КАК ВнешниеОбработки
	              	|ГДЕ
	              	|	ВнешниеОбработки.КомментарийКФайлуИсточнику ПОДОБНО &СтрокаПоиска
	              	|
	              	|ОБЪЕДИНИТЬ ВСЕ
	              	|
	              	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	              	|	ВнешниеОбработкиПринадлежность.Ссылка,
	              	|	ВнешниеОбработкиПринадлежность.НомерСтроки
	              	|ИЗ
	              	|	Справочник.ВнешниеОбработки.Принадлежность КАК ВнешниеОбработкиПринадлежность
	              	|ГДЕ
	              	|	ВнешниеОбработкиПринадлежность.ИмяФайлаПечатнойФормы ПОДОБНО &СтрокаПоиска";

	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(РезультатЗапроса.Выгрузить(), Результат);
	
	Возврат Результат;
	
КонецФункции

// Обновляет значение соответствующего поля для списка элементов справочника "Внешние обработки".
// (См. УстановитьДанныеВХранилищеЗначений)
// 
// Параметры:
// 	ТаблицаЗначений - ТаблицаЗначений - (См. ОписаниеРезультатаПоискаЭлементовПоИмениФайлаИсточника).  
// 	ОписаниеФайла - Структура - (См. ОписаниеФайлаИсточникаДанных).
// 	Адрес - Строка - адрес во временном хранилище, содержащем ДвоичныеДанные.
// 
Процедура УстановитьДанныеВХранилищеЗначенийСписком(Знач ТаблицаЗначений, Знач ОписаниеФайла, Знач Адрес = "") Экспорт
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"Справочник.ВнешниеОбработки.УстановитьДанныеВХранилищеЗначенийСписком",
		"ТаблицаЗначений",
		ТаблицаЗначений,
		Тип("ТаблицаЗначений"));
	
	Для каждого ТекущаяСтрока Из ТаблицаЗначений Цикл
		
		УстановитьДанныеВХранилищеЗначений( ТекущаяСтрока.Ссылка, ОписаниеФайла, Адрес, ТекущаяСтрока.НомерСтроки );
		
	КонецЦикла;
	
КонецПроцедуры

// Обновляет значение соответствующего поля для элемента справочника "Внешние обработки", хранящем двоичные данные 
// файла внешнего отчета, обработки или печатной формы в формате ХранилищеЗначений.
// 
// Параметры:
// 	Ссылка - СправочникСсылка.ВнешниеОбработки - ссылка на элемент справочника.
// 	НомерСтроки - Число - номер строки табличной части "Принадлежность", для которой меняется содержимое файла,
// 		если НомерСтроки = 0, то файл меняется для всего элемента.
// 	ОписаниеФайла - Структура - описание файла-источника, на который меняются
// 		текущие значения (См. ОписаниеФайлаИсточникаДанных).
// 	Адрес - Строка - адрес во временном хранилище, содержащием ДвоичныеДанные.
//
Процедура УстановитьДанныеВХранилищеЗначений(	Знач Ссылка,
												Знач ОписаниеФайла,
												Знач Адрес = "",
												Знач НомерСтроки = 0) Экспорт
	
	Перем ЭтоАдрес;
	Перем ЭлементСправочника;
	Перем НовыеДвоичныеДанные;
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"Справочник.ВнешниеОбработки.УстановитьДанныеВХранилищеЗначенийСписком",
		"Ссылка",
		Ссылка,
		Тип("СправочникСсылка.ВнешниеОбработки"));
		
	ЭтоАдрес = ( НЕ ПустаяСтрока(Адрес) И ЭтоАдресВременногоХранилища(Адрес) );
	
	Если ( НЕ ЭтоАдрес ) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЭлементСправочника = Ссылка.ПолучитьОбъект();
	
	Если ( ЭлементСправочника = Неопределено ) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЭлементСправочника.Заблокировать();
	
	НовыеДвоичныеДанные = Новый ХранилищеЗначения( ПолучитьИзВременногоХранилища(Адрес) );
	
	Если (НомерСтроки = 0) Тогда
		ЭлементСправочника.КомментарийКФайлуИсточнику = КомментарийКФайлу(ОписаниеФайла);
		ЭлементСправочника.ХранилищеВнешнейОбработки = НовыеДвоичныеДанные;
	Иначе
		Индекс = НомерСтроки - 1;
		ЭлементСправочника.Принадлежность[Индекс].ИмяФайлаПечатнойФормы = КомментарийКФайлу(ОписаниеФайла);
		ЭлементСправочника.Принадлежность[Индекс].ХранилищеВнешнейОбработки = НовыеДвоичныеДанные;
	КонецЕсли;

	ЭлементСправочника.Записать();

КонецПроцедуры

// Описание файла-источника данных (обработка, отчет, печатная форма).
// 
// Параметры:
// 	Файл - Файл - существующий файл, описание которого необходимо получить.
// Возвращаемое значение:
// 	Структура - Описание:
// * Имя - Строка- имя файла.
// * Размер - Число - Определяет размер файла (в байтах).
// * ВремяИзменения - Дата - текущая дата на момент вызова функции.
Функция ОписаниеФайлаИсточникаДанных(Знач Файл) Экспорт
	
	Перем ОписаниеФайла;
	
	ОписаниеФайла = Новый Структура;
	ОписаниеФайла.Вставить("Имя", Файл.Имя);
	ОписаниеФайла.Вставить("Размер", Файл.Размер());
	ОписаниеФайла.Вставить("ВремяИзменения", ТекущаяДата());
	
	Возврат ОписаниеФайла;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Инициализирует таблицу значений результата работы функции (См. НайтиПоИмениФайлаИсточника).
// 
// Параметры:
// Возвращаемое значение:
// 	ТаблицаЗначений - Описание:
// * Ссылка - СправочникСсылка.ВнешниеОбработки - ссылка на элемент справочника "Внешние обработки".
// * НомерСтроки - Число - номер строки табличной части, если табличная часть не заполняется, то 0. 
Функция ОписаниеРезультатаПоискаЭлементовПоИмениФайлаИсточника()
	
	Перем Результат;
	Перем ОписаниеЧисла;
	
	Результат = Новый ТаблицаЗначений;
	
	ОписаниеЧисла = ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(2, 0, ДопустимыйЗнак.Неотрицательный);
	
	Результат.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.ВнешниеОбработки"));
	Результат.Колонки.Добавить("НомерСтроки", ОписаниеЧисла);
	
	Возврат Результат;
	   
КонецФункции

// Генерация текста комментария по описанию файла-источника.
// 
// Параметры:
// 	ОписаниеФайла - Структура - (См. ОписаниеФайлаИсточникаДанных).
// Возвращаемое значение:
// 	Строка - сгенерированный комментарий.
Функция КомментарийКФайлу(ОписаниеФайла)
	
	Перем Шаблон;
	Перем ТекстКомментария;
	
	Шаблон = НСтр("ru = 'Исходный файл: %1
                  |размер: %2 байт; сохранен в ИБ: %3; загрузка из внешнего хранилища.'");
	ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
		ОписаниеФайла.Имя, ОписаниеФайла.Размер, ТекущаяДата());
		
	Возврат ТекстКомментария;
	 	
КонецФункции


#КонецОбласти