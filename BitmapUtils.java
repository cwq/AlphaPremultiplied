

import android.graphics.Bitmap;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.IntBuffer;

/**
 * Created by cwq on 16/11/22.
 */
public class BitmapUtils {
    private BitmapUtils() {

    }

    /**
     * 返回透明通道预乘的bitmap
     * 如果config != Bitmap.Config.ARGB_8888 直接放回原bitmap
     * 如果 !isMutable 则copy出新的bitmap再进行操作
     * @param inBitmap 需要透明通道预乘的bitmap
     * @return
     */
    public static Bitmap bitmapAlphaPremultiplied(Bitmap inBitmap) {
        if (inBitmap.getConfig() != Bitmap.Config.ARGB_8888) {
            return inBitmap;
        }
        Bitmap resultBitmpa = null;
        if (!inBitmap.isMutable()) {
            resultBitmpa = inBitmap.copy(Bitmap.Config.ARGB_8888, true);
        } else {
            resultBitmpa = inBitmap;
        }

        int width = resultBitmpa.getWidth();
        int height = resultBitmpa.getHeight();
        ByteBuffer byteBuffer = ByteBuffer.allocate(inBitmap.getByteCount()).order(ByteOrder.LITTLE_ENDIAN);
        // RGBA
        resultBitmpa.copyPixelsToBuffer(byteBuffer);
        byteBuffer.rewind();

        // RGBA to BGRA
        byte[] byteArray = byteBuffer.array();
        for(int i = 0; i < byteArray.length; ) {
            byte tmp = byteArray[i];
            byteArray[i] = byteArray[i + 2];
            byteArray[i + 2] = tmp;
            i += 4;
        }

        int[] pixels = new int[width * height];
        IntBuffer intBuf = byteBuffer.asIntBuffer();
        intBuf.get(pixels);

        // BGRA
        resultBitmpa.setPixels(pixels, 0, width, 0, 0, width, height);

        return resultBitmpa;
    }
}
