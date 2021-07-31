#include "filereader.h"

FileReader::FileReader( QObject *parent ) : QObject( parent ) {}

void FileReader::send()
{
    emit sendString( str );
}

void FileReader::readFile( const QString &path )
{
    QString sfile = QUrl( (QUrl)path ).path();

    QFile file( sfile );

    if ( !file.open( QIODevice::ReadOnly | QIODevice::Text ) ) {
        return;
    }

    QTextStream in( &file );

    qreal cord = 0;
    QString a;

    QRegularExpression re( "(\\d+)(.)(\\d+)(.)([0-9]{2}\\.[0-9]+)(\\w|.){1,"
                   "}([0-9]{2}\\.[0-9]+)" );
    QRegularExpressionMatch match;

    while ( !in.atEnd() ) {
        in >> a;
        match = re.match( a );

        if ( match.hasMatch() ) {
            cord = match.captured( 5 ).toFloat();
            mCoordinates.append( cord );
            cord = match.captured( 7 ).toFloat();
            mCoordinates.append( cord );
        }
    }

    qDebug() << mCoordinates;

    file.close();
}

void FileReader::saveToJson( const QString &path )
{
    QString sfile = QUrl( (QUrl)path ).path();
    sfile.append( "/output.json" );

    QFile file( sfile );
    if ( !file.open( QIODevice::WriteOnly ) ) {
        qDebug() << "oops" << file.errorString();
    }
    file.write( QJsonDocument( mJson ).toJson( QJsonDocument::Indented ) );
    file.close();
}

void FileReader::saveMarker( qreal longitude, qreal latitude )
{
    mJson.insert(
        QString( "point №%1" ).arg( mJson.count() ),
        QJsonValue(
        QString( "%1, %2" ).arg( longitude ).arg( latitude ) ) );
}
