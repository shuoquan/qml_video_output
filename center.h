#include <QObject>
#include <QTime>
#include <QTimer>

class Center : public QObject
{
    Q_OBJECT
public:
    explicit Center(QObject *parent = nullptr);
    ~Center();

signals:
    void updateImgSig(uchar * yuvData);

public slots:
    void OpenYuv();
    void TimeOutSlot();

private:
    FILE* m_pYuvFile;
    unsigned char* m_pBufYuv420p = nullptr;
    int nLen;
    int m_nVideoW;
    int m_nVideoH;
    QTimer *timer;
};
